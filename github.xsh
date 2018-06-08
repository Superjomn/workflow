from github import *
import fire
import datetime
import logging

username = os.environ['github_username']
password = os.environ['github_password']

g = Github(username, password)

def get_issues(start_day, last_ndays, repo='PaddlePaddle/Paddle', type='Issues', label='', author=''):
    '''
    start_day: datetime.datetime
    type: Issues or pr
    '''
    end_day = start_day + datetime.timedelta(days=last_ndays)
    logging.warn('search from date %s to %s' % (start_day, end_day))
    args = dict(
        repo = repo,
        type = type,)
    if label:
        args['label'] = label
    if author:
        args['author'] = author
    for issue in g.search_issues(query='', **args):
        if issue.created_at >= start_day and issue.created_at < end_day:
            print(format_issue(issue))

def format_issue(issue):
    return "- {state}  {title}\n    - {url}".format(
        state = issue.state.upper(),
        title = issue.title,
        url = issue.url
    )

now = datetime.datetime.now()
def time2date(time):
    '''
    time: datetime.datetime
    '''
    return datetime.datetime(time.year, time.month, time.day)

def ndays_ago(ndays):
    return time2date(now) - datetime.timedelta(days=ndays)


# get PR in last week
#get_issues(ndays_ago(6), 7, type='pr', author='Superjomn')

# get User's issues yesterday
get_issues(ndays_ago(1), 1, label='User')

# get User's issues today
#get_issues(ndays_ago(0), -1, label='User')
