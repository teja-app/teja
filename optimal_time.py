import subprocess
import datetime
import os
from collections import Counter


def get_commit_times(repo_path, author_email):
    # Define the git command to get commit dates in ISO 8601 format, filtered by author email
    git_command = [
        "git", "-C", repo_path, "log", "--author", author_email,
        "--date=iso-strict", "--pretty=format:%ad"
    ]

    # Run the git command
    result = subprocess.run(git_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    # Check if the command was successful
    if result.returncode != 0:
        print(f"Error running git log: {result.stderr}")
        return []

    # Split the output by lines to get individual commit timestamps
    commit_timestamps = result.stdout.split('\n')

    return commit_timestamps


def analyze_commit_times(commit_timestamps):
    # Convert string timestamps to datetime objects and extract the hour
    commit_hours = [datetime.datetime.fromisoformat(ts).hour for ts in commit_timestamps if ts]

    # Count commits per hour
    commits_per_hour = Counter(commit_hours)

    # Identify hours with above-average commit activity
    average_commits = sum(commits_per_hour.values()) / len(commits_per_hour)
    active_hours = [hour for hour, count in commits_per_hour.items() if count >= average_commits]

    # Sort active hours to find continuous time slots
    active_hours.sort()

    # Group continuous hours into time slots
    time_slots = []
    start_hour = active_hours[0]

    for i in range(1, len(active_hours)):
        if active_hours[i] - active_hours[i - 1] > 1:
            # If there's a gap larger than an hour, finalize the current time slot
            time_slots.append((start_hour, active_hours[i - 1]))
            start_hour = active_hours[i]
    # Add the last continuous slot
    time_slots.append((start_hour, active_hours[-1]))

    # Calculate the total number of commits for each time slot
    time_slot_commits = []
    for start_hour, end_hour in time_slots:
        total_commits = sum(commits_per_hour[hour] for hour in range(start_hour, end_hour + 1))
        time_slot_commits.append(((start_hour, end_hour), total_commits))

    # Rank the time slots by total commits
    ranked_time_slots = sorted(time_slot_commits, key=lambda slot: slot[1], reverse=True)

    return ranked_time_slots


# Example usage
repo_path = os.getcwd()

author_email = 'i@iraycd.com'


# Assuming current directory is a Git repo
commit_timestamps = get_commit_times(repo_path, author_email)
ranked_time_slots = analyze_commit_times(commit_timestamps)

print("Ranked Prime Time Slots by Commit Activity:")
for ((start_hour, end_hour), total_commits) in ranked_time_slots:
    print(f"From {start_hour:02d}:00 to {end_hour + 1:02d}:00 - Total Commits: {total_commits}")
