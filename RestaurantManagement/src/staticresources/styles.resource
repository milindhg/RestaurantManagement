   
        .orderitem{
            height:40px;
        }
        .quant_label{
            margin-top:5px;
        }
        
        #quant{
            height:35px;
            margin-top:1px;
        }
        .ui-input-text input, .ui-input-search input{
            font-size:12px;
            height:25px;
        }
        .ui-btn-icon-bottom{
        padding-bottom:2em;
        }
        .tablist-left {
        width: 25%;
        display: inline-block;
        }
        .tablist-content {
        width: 60%;
        display: inline-block;
        vertical-align: top;
        margin-left: 5%;
        }
        
        .ui-page-theme{
        background-color:green;
        }
        //.ui-link,.ui-btn{
        //background-color:green;
        //}
        .ui-input-text input, .ui-input-search input{
        min-height:20px;
        height:35px;
        margin-right:10px;
        }
        
        //.ui-link,.ui-btn{
        //background-color:green;
        //}
        
        #billed_items{
        background-color:maroon;
        }
        
        .list-group-item.active.ui-link{
        color:white;
        text-shadow:none;
        font-size:12px;
        }
        
        .list-group-item.active, .list-group-item.active:focus, .list-group-item.active:hover{
        background-image:none;
        background-color:maroon;
        border-color:white;
        font-size:12px;
        }
        
        .list-group{
        background-color:maroon;
        color:maroon;
        font-size:12px;
        }
        
        #panel_body1 {
        padding:0px;
        position: absolute;   
        -webkit-perspective: 1000;
        -moz-perspective: 1000;
        }
        
        .panel_body1 {
        padding:0px;
        position: absolute;   
        -webkit-perspective: 1000;
        -moz-perspective: 1000;
        }
        
        .page1 {
        width: 100%;
        background: white;
        position: relative;
        }
        .page2 {
        width: 100%;
        background: white;
        position: relative;
        display: none;
        }
        
        .slideme {
        max-width: 100%;
        max-height: 100%;
        height: 100%;
        width:100%;
        }
        
        .flip {
        -webkit-backface-visibility:hidden;
        -webkit-transform:translateX(0); 
        -moz-backface-visibility:hidden;
        -moz-transform:translateX(0);
        }
        
        .flip.out {
        -webkit-transform: rotateY(-90deg) scale(.9);
        -webkit-animation-name: flipouttoleft;
        -webkit-animation-duration: 175ms;
        -moz-transform: rotateY(-90deg) scale(.9);
        -moz-animation-name: flipouttoleft;
        -moz-animation-duration: 175ms;
        }
        
        .flip.in {
        -webkit-animation-name: flipintoright;
        -webkit-animation-duration
        : 225ms;
        -moz-animation-name: flipintoright;
        -moz-animation-duration: 225ms;
        }
        
        .flip.out.reverse {
        -webkit-transform: rotateY(90deg) scale(.9);
        -webkit-animation-name: flipouttoright;
        -moz-transform: rotateY(90deg) scale(.9);
        -moz-animation-name: flipouttoright;
        }
        
        .flip.in.reverse {
        -webkit-animation-name: flipintoleft;
        -moz-animation-name: flipintoleft;
        }
        
        @-webkit-keyframes flipouttoleft {
        from { -webkit-transform: rotateY(0); }
        to { -webkit-transform: rotateY(-90deg) scale(.9); }
        }
        
        @-moz-keyframes flipouttoleft {
        from { -moz-transform: rotateY(0); }
        to { -moz-transform: rotateY(-90deg) scale(.9); }
        }
        
        @-webkit-keyframes flipouttoright {
        from { -webkit-transform: rotateY(0) ; }
        to { -webkit-transform: rotateY(90deg) scale(.9); }
        }
        
        @-moz-keyframes flipouttoright {
        from { -moz-transform: rotateY(0); }
        to { -moz-transform: rotateY(90deg) scale(.9); }
        }
        
        @-webkit-keyframes flipintoleft {
        from { -webkit-transform: rotateY(-90deg) scale(.9); }
        to { -webkit-transform: rotateY(0); }
        }
        
        @-moz-keyframes flipintoleft {
        from { -moz-transform: rotateY(-90deg) scale(.9); }
        to { -moz-transform: rotateY(0); }
        }
        
        @-webkit-keyframes flipintoright {
        from { -webkit-transform: rotateY(90deg) scale(.9); }
        to { -webkit-transform: rotateY(0); }
        }
        
        @-moz-keyframes flipintoright {
        from { -moz-transform: rotateY(90deg) scale(.9); }
        to { -moz-transform: rotateY(0); }
        }
        
        h1{
        color:maroon;
        font-weight:bold;
        text-shadow:none; 
        }
        
        .swiper-container {
        width: 100%;
        height: 100%;
        margin-left:auto;
        margin-right:auto;
        padding-bottom:100px;
        }
        
        .swiper-slide {
        text-align: center;
        font-size: 18px;
        background: #fff;
        height: 245px;
        /* Center slide text vertically */
        display: -webkit-box;
        display: -ms-flexbox;
        display: -webkit-flex;
        display: flex;
        -webkit-box-pack: center;
        -ms-flex-pack: center;
        -webkit-justify-content: center;
        justify-content: center;
        -webkit-box-align: center;
        -ms-flex-align: center;
        -webkit-align-items: center;
        align-items: center;
        }
        
        .col-sm-6{
        margin-top:20px;
        padding-top:0px;
        }
        
        .panel-body {
        background-color:white !important;
        text-align:left !important;
        padding:0px;
        }
        
        .cardimage{
        padding:0px;
        margin:0px;
        width:100%;
        background-image:url('{!$Resource.salad}');
        background-repeat:no-repeat;
        background-size:cover;
        top:0;
        right:0;
        height:180px;
        }
        
        .offerimage{
        padding:0px;
        margin:0px;
        width:100%;
        background-image:url('{!$Resource.offer}');
        background-repeat:no-repeat;
        background-size:100%;
        top:0;
        right:0;
        height:100%;
        }
        
        #content2{
        margin:5px;
        background:grey;
        opacity:0.8;
        }
        .content2{
        margin:5px;
        background:grey;
        opacity:0.8;
        }
        
        #desc{
        padding:10px;
        height:50%;
        font-size:16px;
        text-shadow:none;
        }
        
        desc{
        padding:10px;
        height:50%;
        font-size:16px;
        text-shadow:none;
        }
        
        .panel-body > .text-center{
        background-color:grey;
        }
        
        #quantity_desc{
        width:100%;
        float:left;
        padding:0px;
        margin:0px;
        width:100%;
        background-image:url('{!$Resource.salad}');
        background-repeat:no-repeat;
        background-size:100%;
        top:0;
        right:0;
        height:160px;
        }
        
        .quantity_desc{
        width:100%;
        float:left;
        padding:0px;
        margin:0px;
        width:100%;
        background-image:url('{!$Resource.salad}');
        background-repeat:no-repeat;
        background-size:100%;
        top:0;
        right:0;
        height:160px;
        }
        
        .panel-default >.panel-heading {
        background-image:none;
        }
        
        .panel-default >.panel-heading > .panel-title {
        color:white;
        }
        
        #menu_btn, #view_cart_btn{
        background-image:none;
        background-color:maroon;
        text-shadow:none;
        width: 100%;
        height: 50px;
        }
        
        #open_cart{
        background-color:maroon;
        color:white;
        text-shadow:none;
        }
        
        #addorder{
        padding:0px;
        background-color:maroon !important;
        color:White;
        text-shadow:none;
        margin-top:2px;
        height:35px;
        }
        
        #showdetail{
        margin:auto;
        padding:0px;
        font-size:20px;
        width:10px;
        height:20px;
        }
        
        #cart_items {
        position:fixed;
        overflow: scroll;
        right:0;
        width:100%;
        z-index:55;
        }     
        
        #stspecial {
        position:fixed;
        padding:0px;
        left:0;  
        }
        
        #stmenu{
        height:100%;
        position:fixed;
        margin-top:335px;
        left:0;
        overflow:scroll;
        }
        
        #menu_link, #view_cart_link{
        text-align:left;
        background-image:none;
        color: black;
        font-size: 18px;
        text-shadow:none;
        color:white;
        width:100%;
        height:50px;
        padding:5px;
        margin:0px;
        }
        
        .ui-input-text{
        margin:0px;
        }
        
        /**Styling for the new cart UI: Starts **/
        .list-group{
        /* width: 200px;*/
        margin-bottom:0px;
        }
        
        .bs-example{
        margin-bottom: 10px;
        }
        
        .bPageBlock{
        border:0px;
        }
        
        .apexp .bPageBlock.apexDefaultPageBlock .pbBody{
        margin:0px;
        }
        
        /**Styling for the new cart UI: End **/
        
        .est_del{
          display:none;
          font-size:17px;
          font-weight:bold;
          color:maroon;
        }