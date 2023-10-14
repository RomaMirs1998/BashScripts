# System Integrity Assurance

Ensuring system integrity is paramount, especially when it comes to keeping the system free from malware, root-kits, and other malicious modifications. The integrity.sh script aids in this by scanning a given directory and creating SHA-512 hash sums of each file. This aids in tracking file changes and ensuring system integrity.
Table of Contents

- Description
- Usage
- Examples
- Error Handling
    

## Description

The integrity.sh script offers the following functionalities:

    Building an integrity map: Create a map with filenames (including their full path) and their respective SHA-512 hash value.
    Checking an integrity map: Verify the consistency of files against an existing integrity map, providing warnings for modified files.
    Rebuilding an existing map: Update the hash values in an existing integrity map with current file hashes.

## Usage

Create an integrity map:

```bash

./integrity.sh -b [DIRECTORY] [OUTPUT_MAP]

```

Check existing integrity map:

```bash

./integrity.sh -c [EXISTING_MAP]

```
Rebuild existing integrity map:

```bash

    ./integrity.sh -r [EXISTING_MAP]
```
Where:

    [DIRECTORY] is the directory to be scanned (e.g., /boot).
    [OUTPUT_MAP] is the destination file where the integrity map will be saved.
    [EXISTING_MAP] is a previously created integrity map file.

## Examples

To create an integrity map for the /boot directory:

```bash

./integrity.sh -b /boot /tmp/integrity-boot.map
```
To check the integrity using an existing map:

```bash

./integrity.sh -c /tmp/integrity-boot.map
```
To rebuild an existing integrity map:

```bash

    ./integrity.sh -r /tmp/integrity-boot.map
```
## Error Handling

    The script checks for existing maps when using the -b option and provides a warning.
    Errors are thrown if a map doesn't exist when using the -c and -r options.
    The script also checks for proper read/write permissions and provides respective error messages.