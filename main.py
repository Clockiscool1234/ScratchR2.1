import os
from dotenv import load_dotenv
from flask import Flask, send_file, redirect
from flask_wtf.csrf import CSRFProtect
from pages import *

load_dotenv(dotenv_path='.env')

app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY")
app.jinja_env.globals['env_var'] = os.getenv

csrf = CSRFProtect(app)
csrf.init_app(app)

# cdn 
@app.route("/scratchr2/<path:fpath>")
def redirect2CDN(fpath):
    return redirect(f"http://{os.getenv("CDN_ADDR")}/scratchr2/{fpath}")
@app.route("/favicon.ico")
def favicon():
    return send_file("favicon.ico")

# errors
@app.errorhandler(403)
def e404(e):
    return render_template('403.html'), 403
@app.errorhandler(404)
def e404(e):
    return render_template('404.html'), 404

app.register_blueprint(homepage)
app.register_blueprint(account)

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=os.getenv('MAIN_PORT'))