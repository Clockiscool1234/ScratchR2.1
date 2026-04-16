var Scratch = Scratch || {};
Scratch.Gallery = Scratch.Gallery || {};
Scratch.Gallery.Comments = Scratch.Gallery.Comments || {};


Scratch.Gallery.Comments.Router = Backbone.Router.extend({
  routes: {
      ""                : "comments",
      "comments-*id"    :  "comments",
  },
  
  initialize: function() {
    /* Global gallery stuff */ 
    // TODO: remove this, it's only being used in editable fields, adjust editable fields so they don't require it
    this.galleryModel = new Scratch.GalleryThumbnail(Scratch.INIT_DATA.GALLERY.model);
    
    $('#disable-notifications input').on('click', function(e) {Scratch.Gallery.disableNotifications(e, Scratch.INIT_DATA.GALLERY.model.id);}); 
    $('#description.read-only').verticalTinyScrollbar();
    
    this.galleryFollowButton = new Scratch.Gallery.FollowButton({el: '#follow-button', gallery_id: Scratch.INIT_DATA.GALLERY.model.id, displayName: Scratch.INIT_DATA.GALLERY.model.title });
    this.galleryEditTitle = new Scratch.Gallery.EditableField({gallery_id: Scratch.INIT_DATA.GALLERY.model.id, el: '#title'});
    this.galleryEditDescription = new Scratch.Gallery.EditableField({gallery_id: Scratch.INIT_DATA.GALLERY.model.id, el: '#description'});
    this.galleryCoverImage = new Scratch.EditableImage({model: this.galleryModel, el: '#gallery-cover-image'});
    if (Scratch.INIT_DATA.ADMIN) {
      this.adminView = new Scratch.AdminPanel({model: this.projectModel, el: $('#admin-panel')}); 
    }
  },

  comments: function(id) {
    if (id) {
      var commentView = new Scratch.Comments({el: $('#comments'), scrollTo: '-' + id, type: 'gallery', typeId: Scratch.INIT_DATA.GALLERY.model.id});
    } else {
      var commentView = new Scratch.Comments({el: $('#comments'), type: 'gallery', typeId: Scratch.INIT_DATA.GALLERY.model.id});
    }
  },


});

$(function() {
  app = new Scratch.Gallery.Comments.Router();
  Backbone.history.start();
});




