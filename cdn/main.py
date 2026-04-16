import os
import re
from dotenv import load_dotenv
from flask import Flask, send_file

load_dotenv(dotenv_path='.env')

app = Flask(__name__, static_url_path="")
app.jinja_env.globals['env_var'] = os.getenv

@app.route("/scratchr2/static/<path:fpath>")
def redirect2Actfile(fpath):
    dirname = os.path.dirname(fpath)
    fname = os.path.basename(fpath)
    fname = re.sub(r'\.[a-f0-9]{8,}\.', '.', fname)

    strippeddn = re.sub(r'^__\d+__/', '', dirname)
    if strippeddn != dirname:
        return send_file(f"static/scratchr2/static/{strippeddn}/{fname}")

    strippeddn = re.sub(r'^__\d+__//', '', fpath)
    return send_file(f"static/scratchr2/static/{strippeddn}/{fname}")

@app.route("/internalapi/asset/<path:fpath>/get/")
def getAsset(fpath):
    return send_file(f"static/scratchr2/static/medialibraries/{fpath}");

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=os.getenv('CDN_PORT'))
