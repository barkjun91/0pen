var input, output;
var preview;
var converter = new Showdown.converter();
var converterSelector,text;
$("document").ready(function(){
  input = $("#revision_body");
  output = $(".output");
  converterSelector = "preview"
  $("#converter-selector option").each(function(){
    $(this).click(function(){
      converterSelector = $(this).val();
    });
  });
  
  input.keypress(function(){
    output.empty();
    text = converter.makeHtml($(this).val());
    if(converterSelector == 'HTML output') {
      output.text("<h2>HTML로 보기</h2>"+text);
    } else if (converterSelector == 'preview') {
      output.append("<h2>미리보기</h2>"+text);
    }
  });
});
