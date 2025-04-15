import os
import subprocess

print("Starting Streamlit app...")

# Change to the directory where the Python script is located
os.chdir("C:\\Users\\Kadin\\Documents\\Building Streamlit App\\Main Script")

print("Running Streamlit...")
# Run the Streamlit app
subprocess.run(["streamlit", "run", "app.py"])

print("Finished.")