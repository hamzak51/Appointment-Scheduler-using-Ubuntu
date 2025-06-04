#!/bin/bash
# This script sets up folders and files for your project

# Step 1: Create main project folder and subfolders
mkdir -p AppointmentScheduler/reports
mkdir -p AppointmentScheduler/backups

# Step 2: Create a file with some content
echo "Project initialized on $(date)" > AppointmentScheduler/reports/info.txt

# Step 3: Copy the file to the backup folder
cp AppointmentScheduler/reports/info.txt AppointmentScheduler/backups/

# Done
echo "Setup complete. Folders and files created successfully."
