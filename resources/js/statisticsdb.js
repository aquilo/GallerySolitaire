function _7bc68485615362b84aa92b23055a4216efb4c594(){};function _095ca6fd56ea780c6b840ee854c3a1e96f415c5a(){};function _233b4af1958b167b33ed9c5e37068235bfbd81fc(){};function _d35a5608f201a21b79c0429223202bcb2a25c78d(){};function _1adcaa6a5b4810377fbaa801fdf4c1800a6325b6(){};function _8cd177db1e2fadaf19aac61975346959d76a78f5(){};/*jslint sloppy: true */
/*global getDb, dbGetMaxNr, errorCB, dbGetAll, successCB, queryAllSuccess, window */

fields = "datetime, alpha, player, result, less, equal, " +
    "more, minimum, median, mean, " +
    "maximum, mode, scores, trials, nAuto, nMoves";
myDB = "";

function startDb() {
    myDB = window.sqlitePlugin.openDatabase({name: "mySQLite.db", location: 'default'});
    dbCreate();
}   

function getDb() {
  //  return window.sqlitePlugin.openDatabase({name: "mySQLite.db", location: 'default'});
    return myDB;
}

function dbCreate() {
    console.log("... dbCreate");
    myDB.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS STAT (' +
            'datetime TEXT PRIMARY KEY, alpha REAL, player INTEGER, result REAL, less REAL, equal REAL, ' +
            'more REAL, minimum INTEGER, median INTEGER, mean REAL, ' +
            'maximum INTEGER, mode INTEGER, scores INTEGER, trials INTEGER, nAuto INTEGER, nMoves INTEGER)');
        tx.executeSql('CREATE VIEW IF NOT EXISTS STATV as ' +
            'SELECT avg(player) as player, avg(mean) as mean, count(*) as n  FROM STAT');
    },
    errorCB);
}

function getLastGameNr() {
    console.log("... getLastGameNr");
    getDb().transaction(function(tx) {
        tx.executeSql('SELECT MAX(id) AS maxid FROM STAT', [], 
        function (tx, results) {
            if (results.rows.length === 1) {
                gamenr = results.rows.item(0).maxid;
            }
            if (gamenr === null) {
                gamenr = 0;
            }
        }, errorCB);
    }, errorCB);
}


// --------------------------------------------------

function getAllStats() {
    console.log("... getAllStats");
    var sel = 'SELECT sum(case when player < mean then 1 else 0 end) as hwins, sum(case when player = 0 or minimum = 0 then 1 else 0 end) as hsolvable, sum(case when player < minimum then 1 else 0 end) as hminwins, sum(case when player = mean then 1 else 0 end) as hdrawn, sum(case when player = 0 then 1 else 0 end) as hzeros, sum(case when player > minimum then 1 else 0 end) as hcbetter, avg(player) as player, avg(mean) as mean, count(*) as n, sum(nauto) as nauto, sum(nmoves) as nmoves, avg(less) as less, avg(equal) as equal, avg(more) as more, avg(result) as result, sum(case when player <= minimum then 1 else 0 end) as nobetter ';

 //   var query = sel + 'FROM STAT UNION ALL ' + sel + 'FROM (select * from STAT order by ROWID desc limit(20)) UNION ALL ' + sel + 'FROM (select * from STAT order by ROWID desc limit(50)) UNION ALL ' + sel + 'FROM (select * from STAT order by ROWID desc limit(100)) UNION ALL ' + sel + 'FROM (select * from STAT order by ROWID desc limit(200)) UNION ALL ' + sel + 'FROM (select * from STAT order by ROWID desc limit(500)) UNION ALL ' + sel + 'FROM (select * from STAT order by ROWID desc limit(1000)) UNION ALL ' + sel + 'FROM (select * from STAT order by ROWID desc limit(2000)) UNION ALL ' + sel + 'FROM (select * from STAT order by ROWID desc limit(5000))';

    var query = sel + 'FROM (select * from STAT order by ROWID desc limit(100)) UNION ALL ' + sel + 'FROM (select * from STAT order by ROWID desc limit(1000)) UNION ALL ' + sel + 'FROM (select * from STAT order by ROWID desc)  ' ;
    getDb().transaction(function(tx) {
      tx.executeSql(query, [], 
        function(tx, results) {
            var len = results.rows.length;
            var r = results.rows.item(len - 1);
            var s;
            global_statistics = r;
            var nn = r.n;
            var rrr = '<table class="statsummary" border="0.0px" style="font-size: 12px">';
            //   console.log(JSON.stringify(r));
            aaa = results;
            console.log(results.rows);
            var k = -1;
            do {
                k = k + 1;
            } while (results.rows.item(k).n !== nn);
            len = k + 1;
        
            good_be = 81.6;
            good_mean = 21.7;
            good_zeros = 14.6;
            good_zerosolved = 45.6;
            good_solvsolv = 45.6;
            good_best = 23.9;
            good_meanres = 78.2;
            good_bettermean = 85.6;
        
            function compareres(val, goodval, cls1, cls2) {
                cls = (val > goodval) ? cls1 : cls2;
                return '<td class="' + cls + '">' + round_number(val, 2) + '</td>';
            }
        
            rrr += '<tr><th># of games (last &#8230;)</th>';
            for (var i = 0; i < len; i++) {
                rrr += '<td>' + results.rows.item(i).n + '</td>';
            }
            rrr += '<th>good:</th></tr>';
        
            rrr += '<tr><th>% better or equal</th>';
            for (var i = 0; i < len; i++) {
                rrr += compareres(results.rows.item(i).more + results.rows.item(i).equal, good_be, 'valbetter', 'valworse');
            }
            rrr += '<th>' + good_be + '</th></tr>';
        
            rrr += '<tr><th>mean score</th>';
            for (var i = 0; i < len; i++) {
                rrr += compareres(results.rows.item(i).mean, good_mean, 'valworse', 'valbetter');
            }
            rrr += '<th>' + good_mean + '</th></tr>';
        
            rrr += '<tr><th>% games with score 0</th>';
            for (var i = 0; i < len; i++) {
                s = results.rows.item(i);
                rrr += compareres(percent(s.hzeros, s.n, 2), good_zeros, 'valbetter', 'valworse');
            }
            rrr += '<th>' + good_zeros + '</th></tr>';
        
            rrr += '<tr><th>% solved of solvable</th>';
            for (var i = 0; i < len; i++) {
                s = results.rows.item(i);
                rrr += compareres(percent(s.hzeros, s.hsolvable, 2), good_solvsolv, 'valbetter', 'valworse');
            }
            rrr += '<th>' + good_solvsolv + '</th></tr>';
        
            rrr += '<tr><th>% best result</th>';
            for (var i = 0; i < len; i++) {
                s = results.rows.item(i);
                rrr += compareres(percent(s.n - s.hcbetter, s.n, 2), good_best, 'valbetter', 'valworse');
            }
            rrr += '<th>' + good_best + '</th></tr>';
        
            rrr += '<tr><th>% mean result</th>';
            for (var i = 0; i < len; i++) {
                s = results.rows.item(i);
                rrr += compareres(s.result, good_meanres, 'valbetter', 'valworse');
            }
            rrr += '<th>' + good_meanres + '</th></tr>';
        
            rrr += '<tr><th>% better than c\'s mean</th>';
            for (var i = 0; i < len; i++) {
                s = results.rows.item(i);
                rrr += compareres(percent(s.hwins, s.n, 2), good_bettermean, 'valbetter', 'valworse');
            }
            rrr += '<th>' + good_bettermean + '</th></tr>';
            rrr += '</table>';

            statText = [
                '<h2>Your Results</h2>',
                '<div class="rules">For comparison: <i>empirical results</i>.<br><br>',
        
                '<h3>Basic Indicators</h3>',
                '<strong>Number of games</strong>: <b>' + round_number(r.n, 2) + '</b>',
                '<br/>Mean score: <b>' + round_number(r.player, 2) + '</b>',
                '&nbsp;&nbsp;(<i>21.6</i>; computer: ' + round_number(r.mean, 2) + ')<br><br>',
        
                '<h3>Winning Situations</h3>',
                '<strong>Games with score 0</strong>: <b>' + percent(r.hzeros, r.n, 2) + '%</b> (<i>14.4%</i>)',
                ', but solvable were at least <strong>' + percent(r.hsolvable, r.n, 2) + '%</strong> (<i>31.7%</i>). <br>This means that you solved at most <b>' + percent(r.hzeros, r.hsolvable, 2) + '%</b> (<i>44.8%</i>) of all solvable games.<br><br>',
        
                '<h3>Comparisons</h3>',
                'Comparisons to the random tapping "strategy": ',
        
                '</p><strong>Best Result</strong>: In only <b>' + percent(r.n - r.hcbetter, r.n, 2) + '%</b> (<i>23.6%</i>) ',
                'you achieved the best possible result.</p>',
        
                '</p><strong>Perfect Games</strong>: You are at least as good as the computer in <b>' + round_number(r.more + r.equal, 2) + '%</b> (<i>81.6%</i>) ',
                'of the games (compared to the computer your result was better result in <strong>' + round_number(r.more, 1) + '%</strong>, equal in <strong>' + round_number(r.equal, 1) + '%</strong>, and worse in <strong>' + round_number(r.less, 1) + '%</strong>.</p>',
                '<hr>',
                '<strong>Mean result</strong>: <b>' + round_number(r.result, 2) + '%</b> (<i>78.1%</i>)<br/>',
                'The result of a single game is the percentage of computer\'s scores worse than your\'s (mean: <strong>' + round_number(r.more, 2) + '</strong>) plus half of the drawn attempts (mean: <strong>' + round_number(r.equal, 2) + ' / 2</strong>). You see this number after a evaluation in the center of ',
                'the horizontal coloured bar.</p>',
        
                '<p><strong>Games won</strong>: <b>' + percent(r.hwins, r.n, 2) + '%</b> (<i>85.2%</i>)',
                '<br>Your score was better than computer\'s mean out of many attempts.</p>',
                '<p>Games better than computer\'s best: <strong>' + percent(r.hminwins, r.n, 2) + ' %</strong>.',
                '<br/>This depends on the number of attempts. With very many attempts the program ',
                'will sometime play the same game as you did - or even a better one.</p>',
                '<h3>Other Indicator</h3>',
                'Auto moves: <b>' + percent(r.nauto, r.nmoves, 1) + ' %</b>. <br>Usual duration of a game: ',
                "<i>1'" + '55"</i> (includes evaluation).',
        
                '<hr><br/><h3>Summary</h3><br>',
                rrr,
                '<br/><br></div>'
        
            ].join('');

        }, errorCB);
  }, errorCB);
}



function dbSave(allValues0) {
    console.log("... dbSave");
    allValues = allValues0;
    getDb().transaction(
        function (tx) {
            var sql = 'REPLACE INTO STAT (' + fields + ') VALUES (' + allValues + ')';            
            console.log(sql);
            tx.executeSql(sql);
        }, errorCB, successCB);
}

function dbDrop() {
    console.log("... dbDrop");
    getDb().transaction(function (tx) {
        var sql = 'DROP TABLE IF EXISTS STAT';
        console.log(sql);
        tx.executeSql(sql);
    }, errorCB, successCB);
}

function doDumpDb(tx) {
    console.log("... doDumpDb");
    getDb().transaction(function(tx) {
        tx.executeSql('SELECT * FROM STAT', [], 
        function (tx, results) {
            var r = results.rows.item(0),
                csvData = "",
                len = results.rows.length,
                i,
                obj,
                key;
            for (i = 0; i < len; i += 1) {
                obj = results.rows.item(i);
                if (i === 0) {
                    for (key in obj) {
                        csvData += key + ",";
                    }
                    csvData += "$\n";
                }
                for (key in obj) {
                    csvData += obj[key] + ",";
        
                }
                csvData += "$\n";
            }
            global_csv = csvData;
            console.log(global_csv);
            cordova.plugins.email.open({
                subject: 'GallerySolitaire Data, ' + new Date(),
                body: global_csv,
                isHtml: false
            })
        }, 
        errorCB);
    }, errorCB);
}

// --------------------------------------------------

function errorCB(err) {
    console.log("... !!!! errorCB");
    console.log("Error processing SQL: " + err.code + ": " + err.message);
}

function successCB(tx, tresults) {
    console.log("... successCB");
    console.log(tresults.rows.length);
}

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

function setStepsPref() {
    //  console.log('steps: ' + global_steps);
    window.localStorage.setItem('steps', global_steps);
}

function get1Pref(prefName, defaultValue) {
    var pref = window.localStorage.getItem(prefName);
    if (pref === 'undefined' || pref === 'null' || pref === null || pref === 'NaN') {
        pref = defaultValue;
        window.localStorage.setItem(prefName, pref);
    } else {
        if (typeof pref !== "boolean") {
            if (pref === 'false') {
                pref = false;
            } else if (pref === 'true') {
                pref = true;
            } else {
                if (defaultValue !== '---') {
                    pref *= 1;
                }
            }
        }
    }
    //  console.log(prefName + " " + pref + " " + typeof pref);
    //  console.log("get " + prefName + " " + pref + " " + typeof pref);
    return pref;
}

function set1Pref(prefName, pref) {
    //  console.log("save " + prefName + " " + pref + " " + typeof pref);
    window.localStorage.setItem(prefName, pref);
}

function getAllPrefs() {
    global_helplevel = get1Pref("helplevel", 0);
    global_steps = get1Pref("steps", 30);
    global_mtime = get1Pref("speed", 250);
    global_colorblind = get1Pref("colorblind", 2);
 //   global_cardface = get1Pref("cardface", 1);
    global_cardface = 2;
    global_resimg = get1Pref('resimg', '---');
    global_auto = get1Pref("auto", 1);

}

function setAllPrefs() {
    set1Pref("helplevel", global_helplevel);
    set1Pref("steps", global_steps);
    set1Pref("speed", global_mtime);
    set1Pref("colorblind", global_colorblind);
    set1Pref("cardfacecolorblind", global_colorblind);
    set1Pref("auto", global_auto);
}

function bufferToBase64(buf) {
    var binstr = Array.prototype.map.call(buf, function (ch) {
        return String.fromCharCode(ch);
    }).join('');
    return btoa(binstr);
}
function doSaveResultImage(img) {
    var base64 = img.sourceImg.toDataURL();
    set1Pref("resimg", base64);
}
   
function round_number(num, dec) {
    return Math.round(num * Math.pow(10, dec)) / Math.pow(10, dec);
}

function percent(ip, itot, dec) {
    if (itot > 0) {
        return round_number((100.0 * ip) / itot, dec);
    }
    return '(?)';
}
