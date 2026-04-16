var Scratch = Scratch || {};
Scratch.Gallery = Scratch.Gallery || {};
Scratch.Gallery.Curators = Scratch.Gallery.Curators || {};
Scratch.Gallery.DEFAULT_NEXT_PAGE_SELECTOR = "#curator-content";

Scratch.Gallery.Curators.Router = Backbone.Router.extend({
  routes: {
      ""            :  "curators",
  },

  initialize: function() {
    Scratch.Gallery.nextPage('#owner-content', $('#owner-loader'));
    Scratch.Gallery.nextPage('#curator-content');
    $(window).scroll(Scratch.Gallery.pageScroll);

    /* Global gallery stuff */
    // TODO: remove this, it's only being used in editable fields, adjust editable fields so they don't require it
    this.galleryModel = new Scratch.GalleryThumbnail(Scratch.INIT_DATA.GALLERY.model);

    this.galleryFollowButton = new Scratch.Gallery.FollowButton({el: '#follow-button', gallery_id: Scratch.INIT_DATA.GALLERY.model.id, displayName: Scratch.INIT_DATA.GALLERY.model.title });
    this.galleryEditTitle = new Scratch.Gallery.EditableField({gallery_id: Scratch.INIT_DATA.GALLERY.model.id, el: '#title'});
    this.galleryEditDescription = new Scratch.Gallery.EditableField({gallery_id: Scratch.INIT_DATA.GALLERY.model.id, el: '#description'});
    this.galleryCoverImage = new Scratch.EditableImage({model: this.galleryModel, el: '#gallery-cover-image'});
    if (Scratch.INIT_DATA.ADMIN) {
      this.adminView = new Scratch.AdminPanel({model: this.projectModel, el: $('#admin-panel')});
    }
    this.ownerLoadButton = new Scratch.Gallery.LoadButton({el: '#owner-loader'});

    /* Local to curator */
    $('#description.read-only').verticalTinyScrollbar();

    /* NOTE: don't place anything new below here, there is a backbone error caused by an older verison of backbone.js that prevents anything else from running */
    this.curatorList = new Scratch.Gallery.CuratorList({el: $('#curator-content'), gallery_id: Scratch.INIT_DATA.GALLERY.model.id});
    this.ownerList = new Scratch.Gallery.CuratorList({el: $('#owner-content'), gallery_id: Scratch.INIT_DATA.GALLERY.model.id});
    this.addToGallery = new Scratch.Gallery.AddToGalleryBar({el: $('#explore-bar')});
    this.curatorDialog = new Scratch.Gallery.AddCuratorBy({el: $('#curator-action-bar'), gallery_id: Scratch.INIT_DATA.GALLERY.model.id});
    this.addCuratorsFromList = new Scratch.Gallery.AddCuratorsFromList({el: $('#explore-bar'), gallery_id: Scratch.INIT_DATA.GALLERY.model.id, add_to_el: $('.media-grid.curators')});
    if ($('#curator-invite').length) {
      this.invite = new Scratch.Gallery.AcceptCuratorInvite({ el: $('#curator-invite'), gallery_id: Scratch.INIT_DATA.GALLERY.model.id});
    }

    this.galleryReport = new Scratch.Gallery.Report({model: this.galleryModel});
  },
});


$(function() {
  app = new Scratch.Gallery.Curators.Router();
  Backbone.history.start();
});
