# EC2 Metadata Retrieval Script

This Python script queries metadata from an AWS EC2 instance using the Instance Metadata Service (IMDSv2). It provides functions to get all metadata or specific metadata keys from the instance.

## Features

- **Token-Based Authentication:** Use a PUT request to retrieve an API token for secure access to instance metadata.
- **Recursive Metadata Retrieval:** Handles nested metadata keys to fetch and organize sub-metadata.
- **Custom Metadata Selection:** Allows retrieval of specific metadata keys if provided.

## Prerequisites

- **AWS EC2 Instance:**  
  This script must be run on an AWS EC2 instance, as it relies on the instance metadata service (`http://169.254.169.254`). (This case, the OS is Amazon Linux)
- **Key Pair for SSH Access:**  
 We need to have a key pair for SSH access to the EC2 instance. Use the following command to set the permission and connect:
  ```bash
  ssh -i <key-pair.pem> ec2-user@<EC2-IP-Address>
  ```
  ```bash
  chmod 400 <key-pair.pem>
  ```
   
- **Python 3.x**
- **`requests` Library:**  
  Install the library using the following command:
  ```bash
  pip install requests

## How It Works

1. **Get API Token:**  
   The script first obtains an API token from the IMDSv2 service using a PUT request.
   
2. **Fetch Metadata:**  
   - If no keys are specified, the script fetches all available metadata.
   - If specific keys are provided, the script will filter all metadata.
   
3. **Recursive Retrieval:**  
   For nested metadata paths, the script recursively resolves sub-metadata.

4. **Output:**  
   Metadata is returned as a JSON-formatted string.
   - All Metadata: The script gets and displays all metadata for the EC2 instance.
   - Specific Metadata: Specify keys (e.g., ami-id and ami-launch-index) to retrieve only those metadata values.

## Usage

### Running the Script
To run the script, execute:

```bash
python3 get_metadata_ec2.py
```

## Example Output
- All Metadata:

```json
{
    "ami-id": "ami-01816d07b1128cd2d",
    "ami-launch-index": "0",
    "ami-manifest-path": "(unknown)",
    "block-device-mapping/": [
        "ami",
        "root"
    ],
    ...
}
```
- Specific Metadata:

```json
{
    "ami-id": "ami-01816d07b1128cd2d",
    "ami-launch-index": "0",
}