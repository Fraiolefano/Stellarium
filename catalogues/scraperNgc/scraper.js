tables = document.getElementsByClassName("wikitable sortable jquery-tablesorter");
data = []
for (x of tables)
{
    cols = x.getElementsByTagName("td");
    row = "";
    counter =0;
    for (y in cols)
    {
        counter+=1;
        row+="|"+cols[y].innerText;
        if (counter==7)
        {

            data.push(row);
            row="";
            counter=0;
        }
    }
}

for (d of data)
{
    console.log(d);
}