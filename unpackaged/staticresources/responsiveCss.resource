@import url('https://fonts.googleapis.com/css?family=Open+Sans');

body {
    font-size: 15px;
    font-family: "Open Sans", Helvetica, Arial, sans-serif;
    background: #cbcdcf;
}
body a:hover {
    text-decoration: underline;
    color: #0b4d89;
}
textarea {
    padding: 10px;
}
input {
    padding: 5px 10px;
    font-size: 13px;
}

body .bPageBlock {
    border-top: 2px solid #f49644;
    border-bottom: none;
    margin-bottom: 9px;
    background-color: #222;
    background-image: url(/img/bgPageBlockLeft.gif);
    background-repeat: no-repeat;
    background-position: left bottom;
    padding-bottom: 9px;
    clear: both;
}
.bEditBlock .pbHeader>table, .apexp .bPageBlock.apexDefaultPageBlock .pbHeader>table, #ep.bLayoutBlock .pbHeader>table {
    border-bottom: none;
}
body .bPageBlock, body #bodyCell .bResource .secondaryPalette, body .secondaryPalette.bPageBlock, body .individualPalette .secondaryPalette.bPageBlock, body .bodyDiv .genericTable, body .genericPageBlockTable, body .bodyDiv .bSubBlock, body .bComponentBlock .bPageBlock, body .bMyDashboard .bPageBlock, body.rlHoverFrame .bPageBlock, body.subjectSelectionPopup div.choicesBox, body.lookupTab .secondaryPalette.bPageBlock, body.popupTab .secondaryPalette.bPageBlock, body.UserTagStatsPage .secondaryPalette.bPageBlock {
    border: none;
    border-top: 2px solid #f49644;
}

/* Table */

.bPageBlock .detailList .data2Col {
    padding-top: 2px;
    padding-right: 10px;
    padding-bottom: 2px;
    padding-left: 10px;
    text-align: left;
    width: 82%;
}
e .x-grid3-row-over,body .pbBody table.list tr.dataRow.highlight td,body .pbBody table.list tr.dataRow.highlight th {
    background-color:#EDFAFF;
}

/* Form Body */

body .bPageBlock, body .bPageBlock .pbBody, body .bPageBlock .pbBottomButtons {
    background-color: #fafbfc;
    background-image: none;
    margin: 0;
}
.apexp .bPageBlock.apexDefaultPageBlock .pbBody {
    margin: 0;
    border: 10px solid #cbcdcf;
    padding-bottom: 20px;
}

/* Button */

body button, body .x-btn, body .btn, body .btnDisabled, body .btnCancel, body .menuButton .menuButtonButton {
    color: #333;
    margin: 1px;
    padding: 8px 18px;
    border: 2px solid #f49644;
    font-weight: bold;
    font-size: .9em;
    -moz-border-radius: 3px;
    -webkit-border-radius: 3px;
    border-radius: 3px;
    color: #fff;
    background-color: #f49644;
    background: #f49644;
}
body input.btn, body input.btnDisabled, body input.btnCancel {
    padding: 10px 20px;
}
body .dataCell .btn {
    display: inline-block;
    padding: 2px 5px;
    text-decoration: none;
    margin-right: 5px;
    /*background-color: transparent;*/
    /*color: #f49644;*/
    /*border-color: #0b4d89;*/
    /*color: #0b4d89;*/
}
body input.btn[value='Cancel'] {
    background: transparent!important;
    background-color: transparent !important;
    color: #f49644;
}
input[type="file" i] {
    color: #333;
    padding: 15px 20px;
    font-weight: bold;
    font-size: .9em;
    -moz-border-radius: 3px;
    -webkit-border-radius: 3px;
    border-radius: 3px;
    color: #fff;
    background-color: #cecece;
    background: #cecece;
}
/* Header */

body .bPageBlock .pbHeader {
    background-color: #fff;
    padding: 0;
    margin: 0;
}

/* SubHeader */

.pbSubheader {
    background-color: transparent;
    font-weight: bold;
    font-size: 91%;
    padding: 2px 2px 2px 5px;
    margin-top: 25px;
    margin-bottom: 12px;
    overflow: hidden;
}
body .bPageBlock .pbBody .pbSubheader {
    border-width: 2px 0 0;
    border-style: solid;
    color: #27282e;
    padding: 4px 3px;
    padding: 10px 7px;
}

/* Content */

.justify {
    padding: 20px;
}
.pbSubsection {
    padding: 0 20px;
}
body .bPageBlock .pbBody .labelCol, body .bPageBlock .pbBody .dataCol, body .bPageBlock .pbBody .data2Col, body .print .topics-label, body .print .topics-list {
    padding-bottom: 5px;
    padding-top: 10px;
}
.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubheader {
    color: white;
    color: #333;
    border-top: 2px solid #cbcdcf;
}