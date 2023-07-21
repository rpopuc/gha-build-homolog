import sys
import re

errors = []

def parseBranches(payload):
    matches = re.search("##\s+branches\s*([^#]*)", payload, re.IGNORECASE + re.MULTILINE)

    # Strip matches by end line character and get an array of branches
    branches = [branch.strip() for branch in matches.group(1).splitlines()]

    # Remove empty branches
    branches = list(filter(None, branches))

    # Remove branches that have _DELETE_ in the name
    branches = [branch for branch in branches if '_DELETE_' not in branch]

    # strip whitespaces from each branch
    return [branch.strip() for branch in branches]

def getBranches(currentList, mergeList):
    currentList = currentList.split()

    # Strip matches by end line character and get an array of branches
    matches = re.search("##\s+branches\s*([^#]*)", mergeList, re.IGNORECASE + re.MULTILINE)
    branches = [branch.strip() for branch in matches.group(1).splitlines()]
    branches = list(filter(None, branches))

    # percorra branches e verifique as que contém _DELETE_ no nome. Adicione em deleteBranches e remova-as de branches
    deleteBranches = []
    for branch in branches:
        if '_DELETE_' in branch:
            deleteBranches.append(branch.replace('_DELETE_', '').strip())
        else:
            currentList.append(branch.strip())

    # remove from currentList the branches that are in deleteBranches
    for branch in deleteBranches:
        if branch in currentList:
            currentList.remove(branch)

    return currentList

try:
    command = sys.argv[1]

    if command == 'parse-branches':
        print('\n'.join(parseBranches(sys.argv[2])))
        exit()

    if command == 'get-branches':
        print('\n'.join(getBranches(sys.argv[2], sys.argv[3])))
        exit()

    print('["invalid-command"]')

except IndexError as error:
    print(error)
    print('["error"]')