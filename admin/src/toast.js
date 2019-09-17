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
        'task',
        'indent',
        'outdent',
        'divider',
        'table',
        'divider',
        'code',
        'codeblock',
        'divider'
    ];

    editorInstance=new editor(config);
    
    var toolbar = editorInstance.getUI().getToolbar();
    
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
        <input type="text" class="${CLASS_IMAGE_URL_INPUT}" />
        <label for="url">${i18n.get('Description')}</label>
        <input type="text" class="${CLASS_ALT_TEXT_INPUT}" />
        <div class="te-button-section">
            <button type="button" class="${CLASS_OK_BUTTON}">${i18n.get('OK')}</button>
            <button type="button" class="${CLASS_CLOSE_BUTTON}">${i18n.get('Cancel')}</button>
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

    editorInstance.eventManager.listen('closeAllPopup', function() {
        imagePopup.hide();
    });

    editorInstance.eventManager.listen('showMuraImagePopover', function() {
       
        editorInstance.eventManager.emit('closeAllPopup');
        imagePopup.show();

        var  el = imagePopup.$el.get(0);
        var imageUrlInput = el.querySelector(`.${CLASS_IMAGE_URL_INPUT}`);
        var altTextInput = el.querySelector(`.${CLASS_ALT_TEXT_INPUT}`);

        imagePopup.on('shown', function(){ imageUrlInput.focus()});
        imagePopup.on('hidden',function(){ imagePopup.$el.find('input').val('');});

        imagePopup.on('click .te-close-button', function(){imagePopup.hide()});
        imagePopup.on('click .te-ok-button', function(){
            editorInstance.eventManager.emit('command', 'AddImage', {
                imageUrl:imageUrlInput.value,
                altText: altTextInput.value || 'image'
            });
            imagePopup.hide();
        });

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
    var LINK_POPUP_CONTENT = `
        <label for="url">${i18n.get('URL')}</label>
        <input type="text" class="te-url-input" />
        <label for="linkText">${i18n.get('Link text')}</label>
        <input type="text" class="te-link-text-input" />
        <div class="te-button-section">
            <button type="button" class="te-ok-button">${i18n.get('OK')}</button>
            <button type="button" style="margin:unset;hieght:unset;:width:unset;" class="te-close-button">${i18n.get('Cancel')}</button>
        </div>
    `;

    var LinkPopup=editorInstance.getUI().createPopup({
        header: true,
        title: 'Insert link',
        className: 'te-popup-add-image tui-editor-popup',
        content: LINK_POPUP_CONTENT,
        //$target: editorInstance.getUI().getToolbar().$el,
        modal:true
    });
 
    editorInstance.eventManager.listen('showMuraLinkPopover', function() {

        editorInstance.eventManager.emit('closeAllPopup');
        LinkPopup.show();
        
        var  el = LinkPopup.$el.get(0);
        var inputText = el.querySelector('.te-link-text-input');
        var inputURL = el.querySelector('.te-url-input');
        var selectedText = editorInstance.getSelectedText().trim();

        inputText.value = selectedText;

        if (URL_REGEX.exec(selectedText)) {
            inputURL.value = selectedText;
        }
    
        inputURL.focus();

        LinkPopup.on('click .te-close-button', function(){LinkPopup.hide()});
        LinkPopup.on('click .te-ok-button', function(){
            editorInstance.eventManager.emit('command', 'AddLink', {
                linkText:inputText.value,
                url:inputURL.value
            });
            LinkPopup.hide()
        });   

    });

    editorInstance.eventManager.listen('closeAllPopup', function() {
        LinkPopup.hide();
    });
    //END LINK

    return editorInstance;
}