# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.

import csv
from github import Github

def readCSV():
    with open('emails.csv', newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=' ', quotechar='|')
        for row in reader:
            print(', '.join(row))

def writeCSV(email):
    with open('emails.csv', 'a+', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=' ', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        writer.writerow([email])

def writeNewCSV(email):
    existente = False
    with open('emails.csv', newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=' ', quotechar='|')
        for row in reader:
            str = ''.join(row)
            if email == str:
                existente = True
    if existente == False:
        with open('emails.csv', 'a+', newline='') as csvfile:
            writer = csv.writer(csvfile, delimiter=' ', quotechar='|', quoting=csv.QUOTE_MINIMAL)
            writer.writerow([email])

# Press the green button in the gutter to run the script.
if __name__ == '__main__':

    # repo = g.get_repo('mui-org/material-ui')
    # github.search_repositories("topic:quantum topic:quantum-programming")
    # g.search_topics()
    # g.get_repos()
    token = ""
    g = Github(token)

    topics = ["topic:quantum", "topic:quantum-computing", "topic:quantum-algorithms",
              "topic:quantum-information", "topic:quantum-machine-learning", "topic:quantum-cryptography",
              "topic:quantum-programming-language", "topic:quantum-programming", "topic:quantum-computer-simulator",
              "topic:quantumcomputing", "topic:quantum-development-kit", "topic:quantum-computation",
              "topic:quantum-computer", "topic:quantum-chemistry-programs", "topic:ibm-quantum",
              "topic:microsoft-quantum", "topic:quantum-information-science", "topic:quantum-algorithm",
              "topic:quantum-program", "topic:quantum-ai", "topic:quantum-applications",
              "topic:quantum-technology", "topic:quantum-programs", "topic:google-quantum",
              "topic:quantum-software"]

    #topics = g.search_topics(["query=quantum"])
    #for topic in topics:
    #   print("TOPIC - ", topic)

    for topic in topics:
        print("TOPIC - ", topic)

        for repo in g.search_repositories(topic):
            print("REPOSITORY - ", repo.name)

            contributors = repo.get_contributors()
            print("CONTRIBUTORS - ")
            for contributor in contributors:
                print(contributor.email)
                if not isinstance(contributor.email, type(None)):
                    writeNewCSV(contributor.email.__str__())

            #commits = repo.get_commits()
            #print("COMMITS - ")
            #for commit in commits:
            #print(commit.author)
