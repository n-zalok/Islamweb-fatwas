import requests
from bs4 import BeautifulSoup
import csv

session = requests.Session()
main_page = session.get('https://www.islamweb.net/en/fatawa/?pageno=1&q=+*%20+a**%20+*%20&search_txt=ANYSEQ&search_type=All&tab=4')
src = main_page.content
soup = BeautifulSoup(src, 'lxml')
number_of_pages = int(soup.find('ul', {'class': 'pagination'}).find_all('li')[-2].find('a').text.strip())

numbers = []
for num in range(number_of_pages):
    page = session.get(f'https://www.islamweb.net/en/fatawa/?pageno={num+1}&q=+*%20+a**%20+*%20&search_txt=ANYSEQ&search_type=All&tab=4')
    src = page.content
    soup = BeautifulSoup(src, 'lxml')
    slides = soup.find('ul', {'class': 'oneitems'}).find_all('li')

    print(num+1)
    for (i, slide) in enumerate(slides):
        try:
            id = slide.contents[3].contents[1].find('a').text.strip()
            numbers.append(id)
        except IndexError:
            print(f'error in slide {i+1}')

print('done')

with open('ids', 'w', newline='') as myfile:
     wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
     wr.writerow(numbers)
