$(document).ready(function() {
  FA = new scratch.FlashApp();
  $('#project').on('save-title', $.proxy(FA.setProjectData, FA));
});
 
var scratch = scratch || {};

scratch.FlashApp = function(){
  this.obj = null;

  // logged in user
  this.user = {
    username: '',
    userId: null
  }

  // current project
  this.project = {
    creator: null,
    id: null,
    parentId: null,
    title: 'Untitled',
    isPrivate: false,
  }

  this.lastEditorOp = null;
}

scratch.FlashApp.HISTORY_STATE_EDITOR = {
  data: {isEditorMode: true},
  title: document.title + ' - Editor',
  urlParam: '?mode=editor'
}

scratch.FlashApp.HISTORY_STATE_PLAYER = {
  data: {isEditorMode: false},
  title: document.title,
  urlParam: '?mode=player'
}

// Initialize the app
scratch.FlashApp.prototype.init = function(data, id, isEditorMode, standalone) {
  this.deferred = $.Deferred();
  this.user = data.user;
  this.project = data.project;
  this.standalone = standalone 
  if (!standalone) { 
    this.startMode = (isEditorMode) ? scratch.FlashApp.HISTORY_STATE_EDITOR : scratch.FlashApp.HISTORY_STATE_PLAYER;
    this.initHistory();
    this.initUI();
	this.bindUnloadHandler();
  }
  this.obj = this.loadSwf(id);
}

scratch.FlashApp.prototype.bindUnloadHandler = function() {
  this.clearUnloadHandler();
  $(window).bind('beforeunload', this.beforeUnload);
}

scratch.FlashApp.prototype.clearUnloadHandler = function() {
  $(window).unbind('beforeunload');
}

scratch.FlashApp.prototype.beforeUnload = function() {
	if (FA.user.id == null) { // not logged in
		if (FA.obj.ASisUnchanged()) return null;
		if (FA.project.creator == null) { // created a new project
			if (FA.obj.ASisEmpty()) return null;
			return 'To save your changes, cancel navigation then log in.';
		}
		return 'To save your changes, cancel navigation then click remix.';
	} else {
		if (FA.project.creator != FA.user.username) { // remixing an existing project
			if (FA.obj.ASisUnchanged()) return null;
			return 'To save your changes, cancel navigation then click remix.';
		} else {  // my own project
			if (FA.project.isPrivate && (FA.project.title.indexOf('Untitled') == 0)) {
				moveToTrash(FA.project.id); // move to trash now, but move out of trash if renamed
				if (FA.obj.ASisEmpty()) return null;
				return 'To save your changes, cancel navigation and name your project';
			}
		}
	}
	FA.syncSaveProject();
	return null;
}

// save the project data synchronously during page unload
scratch.FlashApp.prototype.syncSaveProject = function() {
	if (FA.obj.ASshouldSave()) {
		var projData = FA.obj.ASgetProject();
		$.ajax({
			   url: '/internalapi/project/' + FA.project.id + '/set/',
			   type: 'POST',
			   async: false, // must be synchronous to ensure that save completes before page unloads
			   data: projData
			   });
	}
}

// Change logged in user - assumes valid username and id
scratch.FlashApp.prototype.setLoginUser = function(username, id) {
  this.user.username = username;
  this.user.id = id;
}

// Update project data
scratch.FlashApp.prototype.setProjectData = function(title) {
  this.project.title = title;
  this.obj.ASsetTitle(title);
}

// Intialize the swf object
swfobject.registerObject('scratch', '10', false);
scratch.FlashApp.prototype.loadSwf = function(id) {
  return swfobject.getObjectById(id);
}

// Initialize the history control
scratch.FlashApp.prototype.initHistory = function() {
  History = window.History;
  if ( History && (History.enabled || '').constructor == Boolean) {
  var state = this.startMode; 
  state.data.initial = true;
  $(window).trigger('statechange');
  History.replaceState(state.data, state.title, state.urlParam);
 
  var fa = this; 
  History.Adapter.bind(window, 'statechange', function() {
    $.when(fa.deferred).then(function(){ 
      var state = History.getState();
      fa.setFullScreen(state.data.isEditorMode);
      fa.obj.ASsetEditMode(state.data.isEditorMode);
    });
  });
  }
}

scratch.FlashApp.prototype.loadProject = function() {
  this.obj.ASsetEmbedMode(true);
  this.obj.ASloadProject(this.project.creator, this.project.id, this.project.title, this.project.isPrivate, false);
  this.obj.ASsetLoginUser(this.user.username);
  if (this.startMode.data.isEditorMode) {
    tip_bar_api.show()
  }
 
}

// #TODO: Rename to toggleMode. 
// Toggles between edit and player mode and updates the history stack accordingly.
scratch.FlashApp.prototype.setEditMode = function(isEditorMode) {
  if (!isEditorMode && (this.user.username != this.project.creator)) {
    this.loadProject()
  }
  if (!isEditorMode) {
    //this.updateTimestamp();
    tip_bar_api.hide(); 
  } else {
    tip_bar_api.show();
  }
  var current = History.getState();
  if (current.data.initial) {
    var state = (isEditorMode)? scratch.FlashApp.HISTORY_STATE_EDITOR : scratch.FlashApp.HISTORY_STATE_PLAYER;
    History.pushState(state.data, state.title, state.urlParam);
  } else {
    History.back();
  }
}

scratch.FlashApp.prototype.updateTimestamp = function(){
  console.log('updating timestamp');
  if (this.obj.ASisUnchanged()) {
    console.log(this.obj.ASisUnchanged());
    console.log('nochange');
    return null;
  } else {
    project = new Scratch.ProjectThumbnail({pk: this.projectId, fields: {datetime_modified: 'now'}});
    console.log(project);
    project.save();
  }
}

// Changes the layout of the page between editor and player mode. 
scratch.FlashApp.prototype.setFullScreen = function(isFullScreen) {
  if (isFullScreen) {
    $('body').removeClass('editor').addClass('editor');
    window.scrollTo(0, 0);
  } else {
    $('body').removeClass('editor');
  }
}

scratch.FlashApp.prototype.showLogin = function(lastEditorOperation) {
  $('#login-dialog').modal('show');  
  this.lastEditorOperation = lastEditorOperation; 
}

scratch.FlashApp.prototype.onLogin = function(response, status, xhr) {
  if(status && response[0].success) {
    this.clearUnloadHandler();
    this.setLoginUser(response[0].username, response[0].id);
    this.obj.ASsetLoginUser(response[0].username, this.lastEditorOperation);
    $('#login-dialog').modal('hide');
  } else {
    $('#login-dialog .error').text(response[0].msg).show();
  }
}

scratch.FlashApp.prototype.initUI = function() {
  $('#see-inside').on('click.see-inside.toggle', { fa: this }, function(e) {
    e.preventDefault();
    e.data.fa.setEditMode(true);
  });
  // init modal login  
 /* $('#login-dialog').modal({
    backdrop: true,
    show: false
  });
  
  $('#login-dialog').on('click.submit', '#sign-in', { fa: this }, function(e) {
    var loginData = $(this).parents('form').serialize();
    scratch.server.login(loginData, function(response, status, xhr) {
      e.data.fa.onLogin(response, status, xhr);
    });
    return false;
  });
  */
}

scratch.FlashApp.prototype.editTitle = function(str) {
  $('#title input').val(str).focusout().focusin();
}

// Called once the swf is loaded, loads the project initialized in FA 
var tempDoc = document;
var documentReady = false;
function JSeditorReady() {
  // This handles standalone in search player where JSeditorReady
  // may be called multiple times after initial page load
  if (documentReady) {
    FA.loadProject();
    FA.deferred.resolve();
  }
  $(tempDoc).ready(function() {
    documentReady = true;
    FA.loadProject();
    if (!FA.standalone) {
      FA.setFullScreen(FA.startMode.data.isEditorMode);
      FA.obj.ASsetEditMode(FA.startMode.data.isEditorMode);
    }
    FA.deferred.resolve();
  });
}

// Switch between editor and player mode
function JSsetEditMode(isEditorMode) {
  FA.setEditMode(isEditorMode);
}

function JSlogin(lastOperation) {
  FA.showLogin(lastOperation);
}

// Create a new project - This should only be used when the user is logged in
function JScreateProject() {
  // TODO: the editor probably shouldn't call this function at all if not logged in, just clear data
  if (!FA.user.id) {
    window.location.href = '/projects/editor/';
  } else {
    data = {};
    scratch.projects.createProject(data, function(data) {
      JSredirectTo(data.project.id);
    });
  }
}

function JScopyProject() {
  var data = {};
  data['title'] = FA.project.title + ' copy';
  data['parent'] = FA.project.parentId;
  FA.clearUnloadHandler();
  scratch.projects.createProject(data, function(data) {
    FA.obj.ASsetNewProject(data.project.id, data.project.title);
  });
}

function JSremixProject() {
  var data = {};
  data['title'] = FA.project.title + ' remix';
  data['parent'] = FA.project.id;
  FA.clearUnloadHandler();
  scratch.projects.createProject(data, function(data) {
    FA.obj.ASsetNewProject(data.project.id, data.project.title);
  });
}

// TODO: Is this used?
// Answer: Not currently used, but Mitchel wants to add the share button back to the Studio so don't delete.
function JSshareProject() {
  data = {};
  data['isPublished'] = true;
  $.ajax({
    url:  '/api/v1/project/' + FA.project.id + '/',
    type: 'PUT',
    data: JSON.stringify(data),
    success: function() { JSredirectTo('outside'); return 1; },
    dataType: 'text/plain',
    contentType: 'application/json',
    error: function(xhr) { return xhr.errorThrown;},
  });
}

// Switch between presentation and normal mode
function JSsetPresentationMode(isPresentationMode) {
  FA.setFullScreen(isPresentationMode);
}

/*
 * Redirect to a page
 * @param loc: Project id or string: 'mystuff', 'home', 'profile', 'logout', or 'settings'
 */
function JSredirectTo(loc) {
  if (!isNaN(loc)) {
    window.location.href =  '/projects/' + loc + '?mode=editor';
  } else {
    if (loc == 'home') {
      window.location.href ='/';
    } else if (loc == 'profile') {
      window.location.href = '/users/' + FA.user.username;
    } else if (loc == 'mystuff') {
      window.location.href = '/mystuff/';
    } else if (loc == 'about') {
        window.location.href = '/about/';
    } else if (loc == 'settings') {
      // TODO: redirect to account settings
    } else if (loc == 'logout') {
      window.location.href =  '/accounts/logout/'; 
    }
  }
}

function JSeditTitle(str) {
  moveOutOfTrash(FA.project.id); // restores untitled project moved to trash on page unload
  FA.editTitle(str);
}

function moveToTrash(projectId) {
  project = new Scratch.ProjectThumbnail({pk: projectId, fields: {visibility: 'trshbyusr'}});
  project.save({}, {async: false});
}

function moveOutOfTrash(projectId) {
  project = new Scratch.ProjectThumbnail({pk: projectId, fields: {visibility: 'visible'}});
  project.save({}, {async: false});
}

function JScaptureRightClick() {
	function handleMouseDown(evt) {
		if (!evt) var evt = window.event;
		if (!FA.obj.ASisEditMode()) return; // do nothing if not in editor
		var offset = $(FA.obj).offset();
		var scale = (evt.screenX - window.screenX) / evt.pageX; // accounts for browser zoom
		var appX = scale * (evt.pageX - offset.left);
		var appY = scale * (evt.pageY - offset.top);
		if (appY < 24) return; // clicks in the top 24 pixels of SWF give the Adobe menu
		if ((evt.which && (evt.which == 3)) ||
			(evt.button && (evt.button == 2)) ||
			(evt.ctrlKey)) {
				// this is a right click (or ctrl-click of any mouse button)
				var isChrome = navigator.userAgent.indexOf('Chrome') != -1;
				FA.obj.ASrightMouseDown(appX, appY, isChrome);
				evt.preventDefault(); // prevent the Adobe menu
		}
	}
	FA.obj.onmousedown = handleMouseDown;
}

function JSgetZoom() {
	var clientWidth = Math.max(document.body.clientWidth, document.documentElement.clientWidth);
	return document.width / clientWidth
}

// Support for URL and File Drag-n-Drop
// Note: File drag-n-drop only works on some browsers (e.g. FF12 and Chrome 19 but not FF8 or Safari 5.0.5)

function JSsetFlashDragDrop(enable) {
	FA.obj.ondragover = function(evt) { evt.preventDefault(); evt.stopPropagation() }
	FA.obj.ondrop = enable ? handleDrop : null;
}

function handleDrop(evt) {
	var x = evt.clientX;
	var y = evt.clientY;
	var textData = evt.dataTransfer.getData('Text');
	var urlData = evt.dataTransfer.getData('URL');

	if (textData) FA.obj.ASdropURL(textData, x, y);
	else if (urlData) FA.obj.ASdropURL(urlData, x, y);

	var fileCount = evt.dataTransfer.files.length;
	for (var i = 0; i < fileCount; i++) {
		loadFile(evt.dataTransfer.files[i], x, y);
	}
	if (evt.stopPropagation) evt.stopPropagation();
	else evt.cancelBubble = true;
}

function loadFile(file, x, y) {
	function loadError(evt) {
		console.log('Error loading dropped file: ' + evt.target.error.code);
	}
	function loadEnd(evt) {
		var data = evt.target.result;
		if (data.length > 0) FA.obj.ASdropFile(fileName, data, x, y);
	}
	if (window.FileReader == null) {
		console.log('FileReader API not supported by this browser');
		return;
	}
	var fileName = ('name' in file) ? file.name : file.fileName;
	var reader = new FileReader();
	reader.onerror = loadError;
	reader.onloadend = loadEnd;
	reader.readAsDataURL(file);
}
