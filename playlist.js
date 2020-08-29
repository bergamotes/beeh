#!/usr/bin/env node
 //
// playlist.js v0.0
// Render playlist.tsv to pretty svg image
// 2020/08/11 - Edouard De Grave (edouarddegrave@gmail.com)
// on v12.16.3
//
//
// Description:
//    Render playlist.tsv to pretty svg image
//
// Notes:
//    Goes in pair with playlist.sh
//
// Requires:
//    node >= v8
//    @halley/svg.js
//
// Usage:
//   node playlist.js
//    Helpful message describing script process, good practices,
//    quirks and features. Mention defaults if any.
//    Example: oneliner example

const fs = require('fs');
const readline = require('readline');
const svg = require('svg');

const lineReader = readline.createInterface({
    input: fs.createReadStream('playlist.tsv'),
    crlfDelay: Infinity
});

async function buildsvg() {
    const root = svg.make();
    const canvas = root.append("g", "container")
    const data = canvas.append("text", "data")

    root.attr('overflow', 'auto')
        .attr('viewBox', '0 0 350 3000')

    canvas.attr('transform', 'translate(10)')

    data.attr('font-family', 'monospace')
        .attr('font-size', '1em')
        .attr('fill', 'white')
        .x(10)
        .y(20)
        .height(1200)

    const textbox = data.text

    for await (const line of lineReader) {
        let fields = line.split("\t")
        let artist = fields[2].split("-")
        /*     artist = artist[0] === artist[0].toUpperCase() ? artist[0] : artist[1] ? artist[1] : 'goodbye'*/
        textbox.append('tspan')
            .attr('fill', 'skyblue')
            .attr('font-weight', 'bold')
            .attr('x', 0)
            .attr('dy', 15)
            .text(fields[0])
        textbox.append('tspan')
            .attr('dx', 5)
            .text(fields[1])
        textbox.append('tspan')
            .attr('dx', 10)
            .text(artist[0].replace('&', '&amp;'))

    }
    return root
}

async function buildtable() {

    let table = "<table>"

    for await (const line of lineReader) {
        let fields = line.split("\t")
        let artist = fields[2].replace('&', '&amp;')
            .replace(/\(Album\)|\.[^/.]+$/g, "")
            .split("-")
        table += "<tr>"
        table += `
            <td class='index'>${fields[0]}</td>
            <td class='item'>${fields[1]}</td>
            <td class='artist'>${artist[0]}<span class='title'>${artist[1]}</span></td>
            `
        table += "</tr>"
    }

    table += "</table>"
    return table
}

/*buildsvg().then((d) => process.stdout.write(d()))*/

const html_svg = `
<!DOCTYPE html>
<html>

<head>
    <title>playlist</title>
    <style>
    html {
        height: 100%;
    }

    body {
        min-height: 100%;
        width: 100%;
        margin: 0;
        background-color: #282c34;
        padding: 0;
    }

    #wrapper {
        position: relative;
        width: 100%;
        max-width: 800px;
        margin: auto;
    }

    svg {
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
    }

    </style>
</head>

<body>
    <div id="wrapper">`


const html_table = `
<!DOCTYPE html>
<html>

<head>
    <title>playlist</title>
    <style>
    html {
        height: 100%;
    }

    body {
        width: 100%;
        min-height: 100%;
        margin: 0;
        background-color: #282c34;
        padding: 0;
    }

    #header {
        display: block;
        position: relative;
        margin: auto;
        margin-top: 3em;
        width: 85%;
    }


    #wrapper {
        position: relative;
        display: table;
        width: 100%;
        margin: auto;
        font-size: 4.5vw;
    }

    table {
        position: relative;
        left: 0;
        top: 0;
        font-family: monospace;
        color: white;
        border: 0;
        margin: auto;
    }

    table,
    td,
    th {
        border-collapse: collapse;
    }

    tr {
        border-bottom: 1px solid darkgrey;
        height: 2.5em;
    }

    td {
        padding-left: 0.5em;
    }

    .index {
        color: skyblue;
        padding-left: 1em;
    }

    .item {
        color: skyblue;
        font-size: 0.6em;
        text-align: center;
    }

    .artist {
        display: table-cell;
        vertical-align: middle;
    }

    .title {
        color: darkgrey;
        font-size: 0.8em;
        font-style: italic;
    }
    </style>
</head>

<body>
    <div id="wrapper">`

// buildsvg().then((d) => process.stdout.write(html_svg + d() + '</div></body></html>')).catch(e => console.log(e))

buildtable().then((d) => process.stdout.write(html_table + d + '</div></body></html>'))
    .catch(e => console.log(e))