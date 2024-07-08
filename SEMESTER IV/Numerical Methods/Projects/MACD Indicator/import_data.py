import pandas as pd


def get_daily():
    daily = pd.read_csv('nflx_us_d.csv')
    return daily


def get_weekly():
    weekly = pd.read_csv('nflx_us_w.csv')
    return weekly

