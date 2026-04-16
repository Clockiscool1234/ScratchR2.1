from flask import Blueprint, render_template

account = Blueprint('account', __name__)

@account.route("/accounts/modal-registration/")
def modalRegister():
    return render_template('modal-registration.html')