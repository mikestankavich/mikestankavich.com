# Setting Up Cloudflare R2 for Downloads

This guide walks through setting up Cloudflare R2 to host large downloadable files and configuring directory listing.

## Step 1: Create an R2 Bucket

1. Log in to the Cloudflare dashboard
2. Navigate to R2 from the sidebar
3. Click "Create bucket"
4. Name the bucket `mikestankavich-downloads` (or your preferred name)
5. Choose the region closest to your users

## Step 2: Configure Public Access

1. From the R2 dashboard, select your bucket
2. Go to the "Settings" tab
3. Under "Public Access", choose "Public bucket"
4. Enable the option for "List objects"
5. Save your changes

## Step 3: Create R2 API Tokens (for uploading files)

1. In the Cloudflare dashboard, go to "My Profile" > "API Tokens"
2. Create a token with R2 permissions:
   - R2 Storage Bucket Item Read and Write permissions
   - Scope it to the specific bucket you created

## Step 4: Upload Files Using rclone

The easiest way to upload files to R2 is using rclone:

1. Install rclone: `brew install rclone` (on macOS)
2. Configure rclone for R2:

```bash
rclone config create cloudflare-r2 s3 \
  provider=Cloudflare \
  account=YOUR_CLOUDFLARE_ACCOUNT_ID \
  access_key_id=YOUR_R2_ACCESS_KEY_ID \
  secret_access_key=YOUR_R2_SECRET_ACCESS_KEY \
  endpoint=https://YOUR_CLOUDFLARE_ACCOUNT_ID.r2.cloudflarestorage.com
```

3. Upload the large file:

```bash
# Upload a single file
rclone copy public/downloads/keypr-1.6.0.exe cloudflare-r2:mikestankavich-downloads/downloads/

# Or upload entire directory
rclone copy public/downloads/ cloudflare-r2:mikestankavich-downloads/downloads/
```

## Step 5: Test Your Configuration

1. After deploying your site with the `_routes.json` configuration, visit:
   `https://mikestankavich.com/downloads/`

2. You should see a directory listing of your uploaded files

## Notes about R2 Directory Listing

- The default directory listing is basic but functional
- For a more customized appearance, you would need to set up a Worker 
- The listing will display all files in the bucket under the path requested