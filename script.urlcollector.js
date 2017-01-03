// ----
var arr = [], l = document.links;
for(var i=0; i<l.length; i++) {
    if (i == 0) {
        arr.push({ 'index': i,
                   'text': document.title,
                   'link': window.location.href });
        continue;
    }
    arr.push({ 'index': i, 'text': l[i].text, 'link': l[i].href });
}

arr.forEach(function(entry) {
    console.log(entry);
});
