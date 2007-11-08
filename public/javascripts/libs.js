
function muda(sDiv) {
    new Effect.toggle($('secao_atual').value, 'slide');
    new Effect.toggle(sDiv, 'slide');
    $('secao_atual').value = sDiv;
}