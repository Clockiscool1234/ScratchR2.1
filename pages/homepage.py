from flask import Blueprint, render_template

homepage = Blueprint('homepage', __name__)

@homepage.route('/')
def home():
    phP = {'projId':1234,'proj':"placeholder",'userUrl':"#",'user':"placeholder"}
    phG = {'galleryId':1234,'gallery':"placeholder"}
    placeholderD = {
        "featured": [],
        "featuredGallery": [],
        "curated": [],
        "sds": [],
        "remixing": [],
        "loving": [],
        "projCount": 1234567890
    }
    for i in range(10):
        placeholderD["featured"].append(phP)
        placeholderD["featuredGallery"].append(phG)
        placeholderD["curated"].append(phP)
        placeholderD["sds"].append(phP)
        placeholderD["remixing"].append(phP)
        placeholderD["loving"].append(phP)
    return render_template('homepage/index.html', data=placeholderD)