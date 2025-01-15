import os
import random
import string
import time
import uuid
from datetime import datetime
from typing import Literal

import clickhouse_connect
from pydantic import BaseModel

# ClickHouse connection using default Docker credentials
clickhouse_client = clickhouse_connect.get_client(
    host=os.environ.get('CLICKHOUSE_HOST', 'localhost'),
    port=int(os.environ.get('CLICKHOUSE_PORT', 8123)),
    username=os.environ.get('CLICKHOUSE_USER', 'default'),
    password=os.environ.get('CLICKHOUSE_PASSWORD', ''),
    database=os.environ.get('CLICKHOUSE_DATABASE', 'default'),
    # interface='native'
)

def test_connection():
    try:
        result = clickhouse_client.command("SELECT 1")
        print(f"Connection test successful. Result: {result}")
        try:
            count = clickhouse_client.command("SELECT COUNT(*) FROM event_masking")
            print(f"Current number of records in event_masking: {count}")
        except Exception as e:
            print(f"Table might not exist yet: {e}")
        return True
    except Exception as e:
        print(f"Connection test failed. Error: {e}")
        return False


def generate_weighted_timestamp():
    current_time = int(time.time())
    fourteen_days_ago = current_time - (14 * 24 * 60 * 60)
    random_time = random.randint(fourteen_days_ago, current_time)
    random_datetime = datetime.fromtimestamp(random_time)
    hour = random_datetime.hour

    # Define working hours (9 AM to 5 PM)
    if 9 <= hour < 17:
        # Higher probability during working hours
        weight = 0.7
    else:
        # Lower probability outside working hours
        weight = 0.3

    if random.random() < weight:
        return random_datetime
    else:
        return generate_weighted_timestamp()


class EventData(BaseModel):
    event_id: str
    timestamp: datetime
    user_id: str
    role_id: Literal["Policy Admin", "User", "Operator"]
    url: str
    user_agent: str
    organization_id: str
    user_input_language_code: Literal["EN", "DE", "ES", "FR", "IT", "PT", "RU", "ZH", "JA", "KO"]
    user_input_type: Literal[
        "text/plain",
        "application/pdf",
        "application/msword",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "application/vnd.ms-powerpoint",
        "image/jpeg",
        "video/mp4",
        "audio/mpeg"
    ]
    filtered_by_policy_id: str
    event_trigger: Literal["masking", "de_masking", "send"]
    user_input: str
    total_detections: int
    detections_per_type: dict[str, int]

def generate_event_data():
    # Create weighted detection counts based on your real data
    detection_weights = {
        "PERSON": 692,
        "ORGANISATION": 474,
        "LOCATION": 379,
        "DATE": 90,
        "IBAN": 70,
        "IPv4v6": 36,
        "DE_ADRESSE": 26,
        "EMAIL": 23,
        "PHONENUMBER": 22,
        "ORG": 8,
        "US_PASSPORT": 6,
        "CUS": 4,
        "US_BANK_ACCOUNT_NUMBER": 3,
        "DE_TAX_NUMBER": 2,
        "DE_PASSPORT": 1
    }
    
    # Generate random detections based on weights
    detections = {}
    total_detections = 0
    
    for detection_type, weight in detection_weights.items():
        # Higher weights mean higher chance of appearing and higher counts
        if random.random() < (weight / 700):  # Normalized by highest weight
            count = random.randint(1, max(1, weight // 100))
            detections[detection_type] = count
            total_detections += count

    event_data = EventData(
        event_id=str(uuid.uuid4()),
        timestamp=generate_weighted_timestamp(),
        user_id=str(random.randint(1, 10)),
        role_id=random.choice(["Policy Admin", "User", "Operator"]),
        url=random.choice([
            "https://openai.com/chatgpt",
            "https://www.anthropic.com/claude",
            "https://www.google.com/bard",
            "https://www.microsoft.com/en-us/bing/chat",
            "https://huggingface.co/gpt2",
            "https://www.deepmind.com/technologies/large-language-models",
            "https://www.ibm.com/watson",
            "https://ai.meta.com/llama/",
        ]),
        user_agent=random.choice([
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15",
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0",
            "Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1",
            "Mozilla/5.0 (Linux; Android 11; SM-G991B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
        ]),
        organization_id=str(random.randint(1, 10)),
        user_input_language_code=random.choices(
            ["EN", "DE", "ES", "FR", "IT", "PT", "RU", "ZH", "JA", "KO"],
            weights=[0.45, 0.45, 0.02, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01],
        )[0],
        user_input_type=random.choice([
            "text/plain",
            "application/pdf",
            "application/msword",
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            "application/vnd.ms-powerpoint",
            "image/jpeg",
            "video/mp4",
            "audio/mpeg",
        ]),
        filtered_by_policy_id=str(random.randint(1, 10)),
        event_trigger=random.choices(
            ["masking", "de_masking", "send"],
            weights=[0.6, 0.05, 0.3]
        )[0],
        user_input="".join(random.choices(string.ascii_letters + string.digits, k=100)),
        total_detections=total_detections,
        detections_per_type=detections
    )
    return event_data

def create_table_if_not_exists():
    try:
        with open('../tables/event_mastking.sql', 'r') as f:
            create_table_query = f.read()
        clickhouse_client.command(create_table_query)
        print("Table 'event_masking' created or already exists.")
    except Exception as e:
        print(f"Error creating table: {e}")
        raise

def insert_data(event_data: EventData):
    try:
        column_names = [
            'event_id', 'timestamp', 'user_id', 'role_id', 'url', 'user_agent',
            'organization_id', 'user_input_language_code', 'user_input_type',
            'filtered_by_policy_id', 'event_trigger', 'user_input',
            'total_detections', 'detections_per_type'
        ]
        data_dict = event_data.model_dump()
        data_values = [data_dict[col] for col in column_names]
        
        clickhouse_client.insert(
            'event_masking',  # Make sure this matches your table name
            [data_values],
            column_names=column_names
        )
        print(f"✓ Event {event_data.event_id[:8]}... inserted with {event_data.total_detections} detections")
    except Exception as e:
        print(f"Error emitting event: {e}")
        print(f"Data values: {data_values}")
        raise

def main():
    if not test_connection():
        print("Exiting due to connection failure.")
        return

    try:
        create_table_if_not_exists()
        
        # Verify table is empty or show current count
        initial_count = clickhouse_client.command("SELECT COUNT(*) FROM event_masking")
        print(f"Initial record count: {initial_count}")
        
        total = 25000
        print(f"Starting insertion of {total} records...")
        
        for i in range(total):
            event_data = generate_event_data()
            insert_data(event_data)
            if (i + 1) % 100 == 0:
                # Verify total count has increased
                current_count = clickhouse_client.command("SELECT COUNT(*) FROM event_masking")
                print(f"Progress: {i + 1}/{total} records inserted. Total records in table: {current_count}")
                
        # Final count verification
        final_count = clickhouse_client.command("SELECT COUNT(*) FROM event_masking")
        print(f"Final record count: {final_count}")
        print(f"Total records inserted: {final_count - initial_count}")
        
    except Exception as e:
        print(f"An error occurred: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()