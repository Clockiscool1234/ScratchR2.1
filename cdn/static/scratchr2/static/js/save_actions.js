"use strict";

function save_action(action, async) {
    return; // Added by sdg, October 2013

    //console.log(action['type']);
    if (typeof csrf !== 'undefined')
        action["csrfmiddlewaretoken"] = csrf //define csrf in the problem template

    if (async == undefined)
        async = true;
    $.ajax({
        type: "POST",
        url: "/log/",
        data: action,
        success: function() { "";}, //prevents dev ajax workaround from complaining
        async: async,
    });
}

function on_navigate_to(url) {
    var action = {
        type: "navigate_to",
        url: url
    };
    save_action(action);
}

function on_navigate_from(url,data) {
    var action = {
        type: "navigate_from",
        url: url,
        dat: JSON.stringify(data)
    };

    // Must be done synchronously to finish
    save_action(action, false);
}

function on_click_remixbar(fromUrl, toUrl, fromProject, toProject) {
    var action = {
        type: "click_remixbar",
        fromUrl: fromUrl,
        toUrl: toUrl,
        fromProject: fromProject,
        toProject: toProject
    };

    save_action(action, false);
}

function on_click_remixes(fromUrl, toUrl, project) {
    var action = {
        type: "click_remixes",
        fromUrl: fromUrl,
        toUrl: toUrl,
        project: project
    };
    save_action(action);
}

function on_click_projectbox(root, fromUrl, toUrl, project) {
    var action = {
        type: "click_projectbox",
        root: root,
        fromUrl: fromUrl,
        toUrl: toUrl,
        project: project
    };
    save_action(action, false);
}

function on_click_remixtree(root, fromUrl, toUrl, project) {
    var action = {
        type: "click_remixtree",
        root: root,
        fromUrl: fromUrl,
        toUrl: toUrl,
        project: project
    };
    save_action(action);
}
