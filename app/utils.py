import datetime


def get_today_in_isoformat() -> str:
    today = datetime.date.today()
    return today.isoformat()
