# Time Converter

minutes = int(input("Enter minutes: "))

hours = minutes // 60
remaining_minutes = minutes % 60

# Format output properly
if hours == 1:
    hr_text = "1 hr"
else:
    hr_text = f"{hours} hrs"

if remaining_minutes == 1:
    min_text = "1 minute"
else:
    min_text = f"{remaining_minutes} minutes"

print(hr_text, min_text)