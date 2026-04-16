import pymysql.cursors
from dotenv import load_dotenv

load_dotenv(dotenv_path='.env')

connection = pymysql.connect(
    host = os.getenv("DB_HOST"),
    port = os.getenv("DB_PORT"),
    user = os.getenv("DB_USER"),
    password = os.getenv("DB_PASSWORD"),
    charset = "utf8mb4",
    cursorclass = pymysql.cursors.DictCursor,
)