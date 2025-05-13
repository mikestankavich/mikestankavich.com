#!/bin/bash
# Script to upload files from downloads directory to Cloudflare R2 bucket

# Configuration
BUCKET_NAME="mikestankavich-downloads"
SOURCE_DIR="./downloads"
R2_PATH="downloads"  # Path within the bucket

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if rclone is installed
if ! command -v rclone &> /dev/null; then
    echo -e "${RED}Error: rclone is not installed. Please install it first:${NC}"
    echo "  brew install rclone    # on macOS"
    echo "  apt install rclone     # on Ubuntu/Debian"
    exit 1
fi

# Check if rclone is configured for Cloudflare R2
if ! rclone listremotes | grep -q "cloudflare-r2:"; then
    echo -e "${YELLOW}Warning: cloudflare-r2 remote not found in rclone configuration.${NC}"
    echo "Would you like to set it up now? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        echo "Please provide your Cloudflare Account ID:"
        read -r CF_ACCOUNT_ID
        echo "Please provide your R2 Access Key ID:"
        read -r R2_ACCESS_KEY_ID
        echo "Please provide your R2 Secret Access Key:"
        read -r R2_SECRET_ACCESS_KEY
        
        rclone config create cloudflare-r2 s3 \
            provider=Cloudflare \
            account="$CF_ACCOUNT_ID" \
            access_key_id="$R2_ACCESS_KEY_ID" \
            secret_access_key="$R2_SECRET_ACCESS_KEY" \
            endpoint="https://$CF_ACCOUNT_ID.r2.cloudflarestorage.com"
        
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error setting up rclone configuration. Please try again manually.${NC}"
            exit 1
        fi
    else
        echo "Please configure rclone manually before running this script:"
        echo "rclone config create cloudflare-r2 s3 provider=Cloudflare account=YOUR_ACCOUNT_ID access_key_id=YOUR_ACCESS_KEY secret_access_key=YOUR_SECRET_KEY endpoint=https://YOUR_ACCOUNT_ID.r2.cloudflarestorage.com"
        exit 1
    fi
fi

# List files to be uploaded
echo -e "${YELLOW}The following files will be uploaded to R2:${NC}"
find "$SOURCE_DIR" -type f -not -path "*/\.*" | sort

# Confirm upload
echo -e "${YELLOW}Do you want to upload these files to the R2 bucket? (y/n)${NC}"
read -r answer
if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "Upload cancelled."
    exit 0
fi

# Upload files
echo -e "${GREEN}Uploading files to R2 bucket...${NC}"
rclone copy "$SOURCE_DIR" "cloudflare-r2:$BUCKET_NAME/$R2_PATH" --progress

# Check if upload was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Files uploaded successfully!${NC}"
    echo -e "${YELLOW}Files should now be accessible at: https://$BUCKET_NAME.r2.dev/$R2_PATH/${NC}"
else
    echo -e "${RED}Error uploading files. Please check your configuration and try again.${NC}"
    exit 1
fi

# List the content of the bucket to verify
echo -e "${GREEN}Contents of the R2 bucket:${NC}"
rclone ls "cloudflare-r2:$BUCKET_NAME/$R2_PATH"

echo -e "${GREEN}Done!${NC}"