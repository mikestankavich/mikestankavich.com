# Downloads Directory

This directory contains large files that are not tracked in the Git repository.

Files placed in this directory can be uploaded to the Cloudflare R2 bucket using the `upload-to-r2.sh` script.

## Adding New Files

1. Place any downloadable files in this directory
2. Run the upload script: `./upload-to-r2.sh`
3. Files will be available at https://mikestankavich-downloads.r2.dev/downloads/

## Notes

- This directory is excluded from Git tracking (.gitignore)
- The Cloudflare Pages site is configured to redirect `/downloads/*` paths to the R2 bucket
- Directory listing is enabled in the R2 bucket configuration