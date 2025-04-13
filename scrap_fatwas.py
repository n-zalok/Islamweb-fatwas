import requests
from bs4 import BeautifulSoup
import csv
import pandas as pd

with open('errors.csv', 'r') as f:
    content = f.read()
    numbers = content.strip().split(',')
    print(len(numbers))


session = requests.Session()
results = []
errors = []

def get_fatwa_info(block):
    target = block.contents[7]

    title = target.contents[3].contents[1].find('h2').text.strip()
    date = target.contents[3].contents[3].contents[1].contents[3].find('a').text.strip()
    question = target.contents[9].contents[3].find('p').text.strip()

    paragraphs = target.contents[13].contents[7].find_all('p')
    answer = ''
    for paragraph in paragraphs:
        paragraph = paragraph.get_text(strip=True)
        answer = answer + paragraph

    return (title, date, question, answer)

def get_fatwa_subject(head):
    subject = head.contents[1].contents[3].contents[1].find('span').text.strip()
    return subject

for (i, num) in enumerate(numbers):
    page =  session.get(f'https://www.islamweb.net/en/fatwa/{int(num.strip('"'))}')

    src = page.content
    soup = BeautifulSoup(src, 'lxml')

    head = soup.find('div', {'class': 'portalheader'})
    block = soup.find('div', {'class': 'fatwalist'})
    try:
        title, date, question, answer = get_fatwa_info(block)
        subject = get_fatwa_subject(head)

        results.append({'id': int(num.strip('"')), 'subject': subject, 'title': title, 'date': date, 'question': question, 'answer': answer})
        print(i+1)
    except IndexError:
        errors.append(num)
        print(f'error at fatwa {num}')

keys = results[0].keys()
with open('fatwas_unclean.csv', 'w', encoding='utf-8') as output:
    dict_writer = csv.DictWriter(output, keys)
    dict_writer.writeheader()
    dict_writer.writerows(results)

with open('errors.csv', 'w', newline='') as myfile:
     wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
     wr.writerow(errors)

fatwas = pd.read_csv('fatwas_unclean.csv')
fatwas.to_csv('fatwas.csv', index=False)
