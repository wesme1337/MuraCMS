require('codemirror/lib/codemirror.css'); // codemirror
require('tui-editor/dist/tui-editor.css'); // editor ui
require('tui-editor/dist/tui-editor-contents.css'); // editor content
require('highlight.js/styles/github.css');

var editor=require('tui-editor');

getMarkdownEditor=function(config){
    var  URL_REGEX = /^(https?:\/\/)?([\da-z.-]+)\.([a-z.]{2,6})(\/([^\s]*))?$/;
    var buttonStyles="float: left; box-sizing: border-box;outline: none;cursor: pointer;background-color: #fff; width: 22px;height: 22px; border-radius: 0; margin: 5px 3px; border: 1px solid #fff;display: flex;justify-content: center;align-items: center;";
    
    config.toolbarItems=[
        'heading',
        'bold',
        'italic',
        'strike',
        'divider',
        'hr',
        'quote',
        'divider',
        'ul',
        'ol',
        'indent',
        'outdent',
        'divider',
        'table',
        'divider',
        'code',
        'codeblock',
        'divider'
    ];

    var editorInstance=new editor(config);
    
    var toolbar = editorInstance.getUI().getToolbar();

     //BEGIN COMPONENT
    var AddComponent=editorInstance.commandManager.addCommand('markdown',{
        name: 'AddComponent',
        exec: function exec(mde, data) {

            var cm = mde.getEditor();
            var doc = cm.getDoc();
        
            var range = mde.getCurrentRange();
        
            var from = {
                line: range.from.line,
                ch: range.from.ch
            };
        
            var to = {
                line: range.to.line,
                ch: range.to.ch
            };
        
            var componentid = data.componentid;
         
        
            Mura.getEntity('content').loadBy('contentid',componentid,{type:"component",fields:"body"})
                .then(function(component){
                    var text=component.get('body');
                    text = editorInstance.importManager.constructor.decodeURIGraceful(text);
                    text = editorInstance.importManager.constructor.escapeMarkdownCharacters(text);
                    doc.replaceRange(text, from, to);
                    cm.focus();
                });
        }
      });

      var AddComponent=editorInstance.commandManager.addCommand('wysiwyg',{
        name: 'AddComponent',
        exec: function exec(wwe, data) {
            var sq = wwe.getEditor();
            var componentid = data.componentid;

            Mura.getEntity('content').loadBy('contentid',componentid,{type:"component",fields:"body"})
                .then(function(component){
                    var text=editorInstance.importManager.constructor.decodeURIGraceful(component.get('body'));
                    sq.insertHTML(editorInstance.convertor.toHTML(text));
                    wwe.focus();
                });
        }

      });

      editorInstance.addCommand(AddComponent)
    
     toolbar.addButton({
        name: 'MuraComponemt',
        className: 'mi-align-justify',
        event: 'showMuraComponentPopover',
        tooltip: 'Image',
        $el: $('<div style="' + buttonStyles + '"><i class="mi-align-justify"></i></div>')
    }, 13);
 
    editorInstance.eventManager.addEventType('showMuraComponentPopover');
    
    var CLASS_IMAGE_URL_INPUT = 'te-image-url-input';
    var CLASS_ALT_TEXT_INPUT = 'te-alt-text-input';
    var CLASS_OK_BUTTON = 'te-ok-button';
    var CLASS_CLOSE_BUTTON = 'te-close-button';

    var i18n=editorInstance.i18n;

    var COMPONENT_POPUP_CONTENT = `
        <label for="">Select Component</label>
        <select class="te-select-component"><option value="">Select Component</option></select>
        <div class="te-button-section">
            <button type="button" class="btn ${CLASS_OK_BUTTON}">${i18n.get('OK')}</button>
            <button type="button" class="btn ${CLASS_CLOSE_BUTTON}">${i18n.get('Cancel')}</button>
        </div>
    `;

    var componentPopup=editorInstance.getUI().createPopup({
        header: true,
        title: 'Insert Component',
        className: 'te-popup-add-image tui-editor-popup',
        content: COMPONENT_POPUP_CONTENT,
        //$target: editorInstance.getUI().getToolbar().$el,
        modal:true
    });

    var componentSelectInput =Mura(componentPopup.$el.get(0)).find('.te-select-component');
   
    Mura.getFeed('content')
        .where()
        .andProp('moduleAssign').containsValue('00000000000000000000000000000000000')
        .sort('title')
        .getQuery({type:'component',fields:'title'}).then(function(collection){
            collection.forEach(function(item){
                componentSelectInput.append('<option value="'+ Mura.escapeHTML(item.get('contentid')) +  '">'+ Mura.escapeHTML(item.get('title')) +  '</option>')
            })
            //$(componentSelectInput.node).niceSelect();
        });

    componentPopup.on('shown', function(){ componentSelectInput.focus()});
    componentPopup.on('hidden',function(){ componentSelectInput.val('');});

    componentPopup.on('click .te-close-button', function(){componentPopup.hide()});
    componentPopup.on('click .te-ok-button', function(){
        editorInstance.eventManager.emit('command', 'AddComponent', {
            componentid:componentSelectInput.val()
        });
        componentPopup.hide();
    });
   
    editorInstance.eventManager.listen('closeAllPopup', function() {
        componentPopup.hide();
    });

    editorInstance.eventManager.listen('showMuraComponentPopover', function() {
       
        editorInstance.eventManager.emit('closeAllPopup');
        componentPopup.show();

    });
    //END COMPONENT
    
    //BEGIN IMAGE

    toolbar.addButton({
        name: 'MuraImage',
        className: 'mi-picture',
        event: 'showMuraImagePopover',
        tooltip: 'Image',
        $el: $('<div style="' + buttonStyles + '"><i class="mi-picture"></i></div>')
    }, 13);
 
    editorInstance.eventManager.addEventType('showMuraImagePopover');
    
    var CLASS_IMAGE_URL_INPUT = 'te-image-url-input';
    var CLASS_ALT_TEXT_INPUT = 'te-alt-text-input';
    var CLASS_OK_BUTTON = 'te-ok-button';
    var CLASS_CLOSE_BUTTON = 'te-close-button';

    var i18n=editorInstance.i18n;

    var IMAGE_POPUP_CONTENT = `
        <label for="">${i18n.get('Image URL')}</label>
        <input type="text" name="mdimageurl" class="${CLASS_IMAGE_URL_INPUT}" style="width:75%;float:left;"/>
        <button type="button" class="btn mura-finder" data-target="mdimageurl" data-completepath="false" style="width:25%;float:right;">Select Image</button><br/>
        <label for="url">${i18n.get('Description')}</label>
        <input type="text" class="${CLASS_ALT_TEXT_INPUT}" />
        <div class="te-button-section">
            <button type="button" class="btn ${CLASS_OK_BUTTON}">${i18n.get('OK')}</button>
            <button type="button" class="btn ${CLASS_CLOSE_BUTTON}">${i18n.get('Cancel')}</button>
        </div>
    `;

    var imagePopup=editorInstance.getUI().createPopup({
        header: true,
        title: 'Insert Image',
        className: 'te-popup-add-image tui-editor-popup',
        content: IMAGE_POPUP_CONTENT,
        //$target: editorInstance.getUI().getToolbar().$el,
        modal:true
    });

    var imageEl = imagePopup.$el.get(0);
    var imageUrlInput = imageEl.querySelector(`.${CLASS_IMAGE_URL_INPUT}`);
    var imageAltTextInput = imageEl.querySelector(`.${CLASS_ALT_TEXT_INPUT}`);

    imagePopup.on('shown', function(){ imageUrlInput.focus()});
    imagePopup.on('hidden',function(){ imagePopup.$el.find('input').val('');});

    imagePopup.on('click .te-close-button', function(){imagePopup.hide()});
    imagePopup.on('click .te-ok-button', function(){
        editorInstance.eventManager.emit('command', 'AddImage', {
            imageUrl:imageUrlInput.value,
            altText: imageAltTextInput.value || 'image'
        });
        imagePopup.hide();
    });

    editorInstance.eventManager.listen('closeAllPopup', function() {
        imagePopup.hide();
    });

    editorInstance.eventManager.listen('showMuraImagePopover', function() {
        
        imageUrlInput.value='';
        imageAltTextInput.value='';

        editorInstance.eventManager.emit('closeAllPopup');

        imagePopup.show();

        setFinders('button[data-target="mdimageurl"]');

    });
    //END IMAGE

    //BEGIN LINK
    toolbar.addButton({
        name: 'MuraLink',
        className: 'mi-link',
        event: 'showMuraLinkPopover',
        tooltip: 'Link',
        $el: $('<div style="' + buttonStyles + '"><i class="mi-link"></i></div>')
    }, 13);

    editorInstance.eventManager.addEventType('showMuraLinkPopover');

    var i18n=editorInstance.i18n;
    var LINK_POPUP_CONTENT = `<div>
        <label for="url">${i18n.get('URL')}</label>
        <input type="text" id="mdlinkurl" name="mdlinkurl" class="te-url-input" style="width:75%;float:left;"/>
        <button type="button" class="btn mura-finder" data-target="mdlinkurl" data-completepath="false" style="width:25%;float:right;">Select File</button><br/>
        <label for="linkText">${i18n.get('Link text')}</label>
        <input type="text" class="te-link-text-input" />
        <div class="te-button-section">
            <button type="button" class="btn te-ok-button">${i18n.get('OK')}</button>
            <button type="button" class="btn te-close-button">${i18n.get('Cancel')}</button>
        </div></div>
    `;

    var LinkPopup=editorInstance.getUI().createPopup({
        header: true,
        title: 'Insert link',
        className: 'te-popup-add-image tui-editor-popup',
        content: LINK_POPUP_CONTENT,
        //$target: editorInstance.getUI().getToolbar().$el,
        modal:true
    });
 
    $( function() {
        var cache = {};
        $( 'input[name="mdlinkurl"]').autocomplete({
          minLength: 4,
          source: function( request, response ) {
            var term = request.term;
            if(term.substring(1, 4)=='http' || term.substring(1, 1) == "/"){
                return;
            }
            if ( term in cache ) {
              response( cache[ term ] );
              return;
            }
            
            Mura.getFeed('content')
                .where()
                .andProp('title').containsValue(term)
                .sort('title')
                .getQuery({fields:'title,url'}).then(function(collection){
                    var data=[];
                    collection.forEach(function(item){
                        data.push(item.get('url'));
                    })
              
                    console.log(data)
                    cache[ term ] = data;
                    response(data);
                });
          }
        });
      } );

    var linkEl = LinkPopup.$el.get(0);
    var linkInputText = linkEl.querySelector('.te-link-text-input');
    var linkInputURL = linkEl.querySelector('.te-url-input');
 
    LinkPopup.on('click .te-close-button', function(){LinkPopup.hide()});
    LinkPopup.on('click .te-ok-button', function(){
        editorInstance.eventManager.emit('command', 'AddLink', {
            linkText:linkInputText.value,
            url:linkInputURL.value
        });
        LinkPopup.hide()
    });   
    editorInstance.eventManager.listen('showMuraLinkPopover', function() {
        var linkSelectedText = editorInstance.getSelectedText().trim();
        
        linkInputText.value='';
        linkInputURL.value='';

        editorInstance.eventManager.emit('closeAllPopup');

        LinkPopup.show();
        
        setFinders('button[data-target="mdlinkurl"]');
    
        linkInputText.value = linkSelectedText;
        linkInputURL.focus();

        if (URL_REGEX.exec(linkSelectedText)) {
            linkInputURL.value = linkSelectedText;
        }

    });

    editorInstance.eventManager.listen('closeAllPopup', function() {
        LinkPopup.hide();
    });
    //END LINK

    return editorInstance;
}