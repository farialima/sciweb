
function muda(sDiv) {
    new Effect.toggle($('secao_atual').value, 'slide');
    new Effect.toggle(sDiv, 'slide');
    $('secao_atual').value = sDiv;
}

// Funcoes para alterar dinamicamente o tamanho das textareas
// Alem deste codigo foi necessario tambem declarar o seu carregamento: <body onload="cleanForm();">
function countLines(strtocount, cols) {
    var hard_lines = 1;
    var last = 0;
    while ( true ) {
        last = strtocount.indexOf("\n", last+1);
        hard_lines ++;
        if ( last == -1 ) break;
    }
    var soft_lines = Math.round(strtocount.length / (cols-1));
    var hard = eval("hard_lines  " + unescape("%3e") + "soft_lines;");
    if ( hard ) soft_lines = hard_lines;
    return soft_lines;
}

function cleanForm() {
    var the_form = document.forms[0];
    for ( var x in the_form ) {
        if ( ! the_form[x] ) continue;
        if( typeof the_form[x].rows != "number" ) continue;
        the_form[x].rows = countLines(the_form[x].value,the_form[x].cols) +1;
    }
    setTimeout("cleanForm();", 300);
}