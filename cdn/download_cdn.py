import os
import json
import time
import requests
from urllib.parse import urlparse
from concurrent.futures import ThreadPoolExecutor

# --- CONFIGURATION ---
JSON_FILE = 'cdn.json'
MAX_THREADS = 8  
MAX_RETRIES = 9999
BACKOFF_FACTOR = 3 
OK_CODES = [200, 301, 302, 303, 307, 308]

def download_file(entry):
    # 1. Validation Gate: Ignore invalid items
    if not isinstance(entry, list) or len(entry) < 3:
        return "Invalid: Entry is not a valid list format"
    
    original_url = entry[0]
    timestamp = entry[2]
    
    if not original_url or not timestamp:
        return "Invalid: Missing URL or Timestamp"

    try:
        # 2. Path Cleanup
        parsed_url = urlparse(original_url)
        if not parsed_url.netloc:
            return f"Invalid: Could not parse domain from {original_url}"

        clean_path = parsed_url.path.lstrip('/')
        domain = parsed_url.netloc.replace(":", "_")
        
        # Ensure we have a valid directory structure
        dir_part = os.path.dirname(clean_path)
        directory = os.path.join(dir_part)
        
        filename = os.path.basename(clean_path) or "index.html"
        file_path = os.path.join(directory, filename)

        # 3. Skip logic (Non-empty files)
        if os.path.exists(file_path) and os.path.getsize(file_path) > 0:
            return f"Skipped: {file_path}"

        # Safety check: Ensure directory string isn't empty before makedirs
        if directory:
            os.makedirs(directory, exist_ok=True)

        # 4. Wayback Raw URL
        download_url = f"https://web.archive.org/web/{timestamp}id_/{original_url}"
        
        for attempt in range(MAX_RETRIES):
            try:
                response = requests.get(
                    download_url, 
                    stream=True, 
                    timeout=25, 
                    allow_redirects=True
                )
                
                if response.status_code == 429:
                    time.sleep(BACKOFF_FACTOR ** (attempt + 1))
                    continue

                if response.status_code not in OK_CODES:
                    time.sleep(BACKOFF_FACTOR)
                    continue
                
                with open(file_path, 'wb') as f:
                    for chunk in response.iter_content(chunk_size=16384):
                        if chunk:
                            f.write(chunk)
                
                if os.path.exists(file_path) and os.path.getsize(file_path) > 0:
                    return f"Success: {file_path}"
                else:
                    continue

            except (requests.exceptions.RequestException, IOError):
                time.sleep(BACKOFF_FACTOR ** (attempt + 1))

    except Exception as e:
        return f"Error: Unexpected issue with {original_url} | {e}"

    return f"Failed: {original_url} after retries."

def main():
    if not os.path.exists(JSON_FILE):
        print(f"File not found: {JSON_FILE}")
        return

    with open(JSON_FILE, 'r') as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError:
            print("Invalid JSON format.")
            return

    print(f"Processing {len(data)} items...")

    with ThreadPoolExecutor(max_workers=MAX_THREADS) as executor:
        results = list(executor.map(download_file, data))

    # Stats Summary
    success = [r for r in results if r.startswith("Success")]
    failed = [r for r in results if r.startswith("Failed") or r.startswith("Error")]
    invalid = [r for r in results if r.startswith("Invalid")]
    
    print(f"\n--- Done ---")
    print(f"Saved:   {len(success)}")
    print(f"Invalid: {len(invalid)}")
    print(f"Failed:  {len(failed)}")

if __name__ == "__main__":
    main()