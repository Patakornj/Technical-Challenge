import requests
import json

def get_api_token():

    token_url = "http://169.254.169.254/latest/api/token"
    token_headers = {
        "X-aws-ec2-metadata-token-ttl-seconds": "21600"
    }
    token_response = requests.put(token_url, headers=token_headers)

    if token_response.status_code == 200:
        api_token = token_response.text
        return api_token
    else:
        print ("Error: Unable to get token. Status code: ", {token_response.status_code})
        return None


def get_sub_metadata(parent, sub_paths, headers):

    sub_metadata_list = []

    for sub_path in sub_paths:
        sub_metadata_val_url = f"http://169.254.169.254/latest/meta-data/{parent}{sub_path}"
        sub_metadata_val_response = requests.get(sub_metadata_val_url, headers=headers)

        if sub_metadata_val_response.status_code == 200:
            value = sub_metadata_val_response.text

            if value.endswith("/"):
                paths = value.splitlines()
                sub_metadata_list.append(get_sub_metadata(parent, paths, headers))

            else:
                if "\n" in value:
                    sub_metadata_list.append(value.splitlines())
                else:
                    sub_metadata_list.append(value)

        else:
            print(f"Failed to get metadata for {parent}{sub_path}. Status code: {sub_metadata_val_response.status_code}")

    return sub_metadata_list


def get_metadata_ec2(keys=None):

    metadata_dict = {}
    api_token = get_api_token()
    metadata_url = "http://169.254.169.254/latest/meta-data/"
    metadata_headers = {
        "X-aws-ec2-metadata-token": api_token
        }
    metadata_response = requests.get(metadata_url, headers=metadata_headers)

    if metadata_response.status_code != 200:
        print(f"Error: Unable to get metadata. Status code: {metadata_response.status_code}")
        return None

    metadata = (metadata_response.text).splitlines()

    # For a particular data key to be retrieved individually
    if keys:
        metadata = list(set(metadata).intersection(keys))

    for data in metadata:
        metadata_val_url = f"http://169.254.169.254/latest/meta-data/{data}"
        metadata_val_response = requests.get(metadata_val_url, headers=metadata_headers)

        if metadata_val_response.status_code == 200:
            value = metadata_val_response.text

            if value.endswith("/"):
                sub_paths = value.splitlines()
                metadata_dict[data] = get_sub_metadata(data, sub_paths, metadata_headers)
            else:
                if "\n" in value:
                    metadata_dict[data] = value.splitlines()
                else:
                    metadata_dict[data] = value
        else:
             print(f"Failed to get metadata for {data}. Status code: {metadata_val_response.status_code}")

    # Change to JSON format
    metadata_json = json.dumps(metadata_dict, indent=4)
    return metadata_json


# For get all of meta-data
print("======================== All Meta-Data ========================")
all_metadata = get_metadata_ec2()
print(all_metadata)

# For Specific meta-data e.g., ami-id and ami-launch-index
print("======================== Specific Meta-Data ========================")
specific_metadata = get_metadata_ec2(keys=["ami-id", "ami-launch-index"])
print(specific_metadata)
