import json
import os.path
from typing import cast

SUSPICIOUS_KEYWORDS: dict[str, int] = {
    "login": 25,
    "log-in": 25,
    "sign-in": 25,
    "signin": 25,
    "account": 25,
    "verification": 25,
    "verify": 25,
    "webscr": 25,
    "password": 25,
    "credential": 25,
    "support": 25,
    "activity": 25,
    "security": 25,
    "update": 25,
    "authentication": 25,
    "authenticate": 25,
    "authorize": 25,
    "wallet": 25,
    "alert": 25,
    "purchase": 25,
    "transaction": 25,
    "recover": 25,
    "unlock": 25,
    "confirm": 20,
    "live": 15,
    "office": 15,
    "service": 15,
    "manage": 15,
    "portal": 15,
    "invoice": 15,
    "secure": 10,
    "customer": 10,
    "client": 10,
    "bill": 10,
    "online": 10,
    "safe": 10,
    "form": 10,
    "appleid": 70,
    "icloud": 60,
    "iforgot": 60,
    "itunes": 50,
    "apple": 30,
    "office365": 50,
    "microsoft": 60,
    "windows": 30,
    "protonmail": 70,
    "tutanota": 60,
    "hotmail": 60,
    "gmail": 70,
    "outlook": 60,
    "yahoo": 60,
    "google": 60,
    "yandex": 60,
    "twitter": 60,
    "facebook": 60,
    "tumblr": 60,
    "reddit": 60,
    "youtube": 40,
    "linkedin": 60,
    "instagram": 60,
    "flickr": 60,
    "whatsapp": 60,
    "localbitcoin": 70,
    "poloniex": 60,
    "coinhive": 70,
    "bithumb": 60,
    "kraken": 50,
    "bitstamp": 60,
    "bittrex": 60,
    "blockchain": 70,
    "bitflyer": 60,
    "coinbase": 60,
    "hitbtc": 60,
    "lakebtc": 60,
    "bitfinex": 60,
    "bitconnect": 60,
    "coinsbank": 60,
    "paypal": 70,
    "moneygram": 60,
    "westernunion": 60,
    "bankofamerica": 60,
    "wellsfargo": 60,
    "citigroup": 60,
    "santander": 60,
    "morganstanley": 60,
    "barclays": 50,
    "hsbc": 50,
    "scottrade": 60,
    "ameritrade": 60,
    "merilledge": 60,
    "bank": 15,
    "amazon": 60,
    "overstock": 60,
    "alibaba": 60,
    "aliexpress": 60,
    "leboncoin": 70,
    "netflix": 70,
    "skype": 60,
    "github": 60,
    "onedrive": 60,
    "dropbox": 60,
    "cgi-bin": 50,
    "-com.": 20,
    ".net-": 20,
    ".org-": 20,
    ".com-": 20,
    ".net.": 20,
    ".org.": 20,
    ".com.": 20,
    ".gov-": 30,
    ".gov.": 30,
    ".gouv-": 40,
    "-gouv-": 40,
    ".gouv.": 40,
    "suivi": 50,
    "laposte": 50,
    "docomo": 50,
    "jcb": 30,
    "jibun": 50,
    "kuroneko": 60,
    "mitsui": 50,
    "mizuho": 50,
    "mufg": 50,
    "ntt": 30,
    "rakuten": 50,
    "sagawa": 60,
    "saison": 50,
    "smbc": 50,
    "softbank": 50,
    "sumimoto": 50,
    "webmoney": 50,
}


SUSPICIOUS_TLDS: list[str] = [
    "ga",
    "gq",
    "ml",
    "cf",
    "tk",
    "xyz",
    "pw",
    "cc",
    "club",
    "work",
    "top",
    "support",
    "bank",
    "info",
    "study",
    "party",
    "click",
    "country",
    "stream",
    "gdn",
    "mom",
    "xin",
    "kim",
    "men",
    "loan",
    "download",
    "racing",
    "online",
    "center",
    "ren",
    "gb",
    "win",
    "review",
    "vip",
    "tech",
    "science",
    "business",
]


def load_warning_list(path: str) -> list[str]:
    with open(path) as f:
        data = json.loads(f.read())
        return cast(list[str], data.get("list", []))


current_dir = os.path.abspath(os.path.dirname(__file__))


ALEXA_TOP_DOMAINS: list[str] = load_warning_list(
    os.path.join(current_dir, "./data/alexa.json")
)
MS_DOMAINS: list[str] = load_warning_list(os.path.join(current_dir, "./data/ms.json"))
OTHER_DOMAINS: list[str] = load_warning_list(
    os.path.join(current_dir, "./data/other.json")
)

HIGH_REPUTATION_DOMAINS: list[str] = ALEXA_TOP_DOMAINS + MS_DOMAINS + OTHER_DOMAINS
