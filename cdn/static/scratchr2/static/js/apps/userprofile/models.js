Scratch.UserProfile.ProfileModel = Scratch.UserThumbnail.extend({ 
  initialize: function(attributes, options) {
    console.log('inside PROFILE MODEL');
    console.log(options.featured_project);
    this.featuredProject = options.featured_project;
    Scratch.UserThumbnail.prototype.initialize.apply(this, [attributes, options]); 
  },
  
  setFeaturedProject: function(featuredId) {
    options = {};
    options.data = {'featured_project': featuredId}; 
    var self = this;
    options.success = function(resp, status, xhr) {
        self.featuredProject = resp.featured_project; 
        self.trigger('feature-project-updated', self, resp);
    };
    options.data = JSON.stringify(options.data);
    Backbone.sync('update', this, options); 
  },

});


