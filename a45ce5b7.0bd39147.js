(window.webpackJsonp=window.webpackJsonp||[]).push([[31],{132:function(e,t,n){"use strict";n.r(t),n.d(t,"frontMatter",(function(){return o})),n.d(t,"metadata",(function(){return l})),n.d(t,"rightToc",(function(){return c})),n.d(t,"default",(function(){return p}));var a=n(2),i=n(6),r=(n(0),n(155)),o={id:"delimited",title:"Delimited format",sidebar_label:"Delimited format"},l={id:"io/delimited",title:"Delimited format",description:"Import a delimited file as PopData",source:"@site/docs/io/delimited.md",permalink:"/PopGen.jl/docs/io/delimited",editUrl:"https://github.com/pdimens/popgen.jl/edit/documentation/docs/io/delimited.md",sidebar_label:"Delimited format",sidebar:"docs",previous:{title:"Reading in data",permalink:"/PopGen.jl/docs/io/file_import"},next:{title:"Genepop format",permalink:"/PopGen.jl/docs/io/genepop"}},c=[{value:"Import a delimited file as <code>PopData</code>",id:"import-a-delimited-file-as-popdata",children:[{value:"Arguments",id:"arguments",children:[]},{value:"Keyword Arguments",id:"keyword-arguments",children:[]}]},{value:"Formatting",id:"formatting",children:[{value:"Missing data",id:"missing-data",children:[]}]},{value:"Acknowledgements",id:"acknowledgements",children:[]}],b={rightToc:c};function p(e){var t=e.components,n=Object(i.a)(e,["components"]);return Object(r.b)("wrapper",Object(a.a)({},b,n,{components:t,mdxType:"MDXLayout"}),Object(r.b)("h2",{id:"import-a-delimited-file-as-popdata"},"Import a delimited file as ",Object(r.b)("inlineCode",{parentName:"h2"},"PopData")),Object(r.b)("pre",null,Object(r.b)("code",Object(a.a)({parentName:"pre"},{className:"language-julia"}),'delimited(infile::String; delim::Union{Char,String,Regex} = "auto", digits::Int = 3, diploid::Bool = true, silent::Bool = false)\n\n# Example\njulia> a = delimited("/data/cali_poppy.csv", digits = 2)\n')),Object(r.b)("div",{className:"admonition admonition-caution alert alert--warning"},Object(r.b)("div",Object(a.a)({parentName:"div"},{className:"admonition-heading"}),Object(r.b)("h5",{parentName:"div"},Object(r.b)("span",Object(a.a)({parentName:"h5"},{className:"admonition-icon"}),Object(r.b)("svg",Object(a.a)({parentName:"span"},{xmlns:"http://www.w3.org/2000/svg",width:"16",height:"16",viewBox:"0 0 16 16"}),Object(r.b)("path",Object(a.a)({parentName:"svg"},{fillRule:"evenodd",d:"M8.893 1.5c-.183-.31-.52-.5-.887-.5s-.703.19-.886.5L.138 13.499a.98.98 0 0 0 0 1.001c.193.31.53.501.886.501h13.964c.367 0 .704-.19.877-.5a1.03 1.03 0 0 0 .01-1.002L8.893 1.5zm.133 11.497H6.987v-2.003h2.039v2.003zm0-3.004H6.987V5.987h2.039v4.006z"})))),"Windows users")),Object(r.b)("div",Object(a.a)({parentName:"div"},{className:"admonition-content"}),Object(r.b)("p",{parentName:"div"},"make sure to change your backslashes ",Object(r.b)("inlineCode",{parentName:"p"},"\\")," to forward slashes ",Object(r.b)("inlineCode",{parentName:"p"},"/")," "))),Object(r.b)("h3",{id:"arguments"},"Arguments"),Object(r.b)("ul",null,Object(r.b)("li",{parentName:"ul"},Object(r.b)("inlineCode",{parentName:"li"},"infile::String")," : path to the input file, in quotes")),Object(r.b)("h3",{id:"keyword-arguments"},"Keyword Arguments"),Object(r.b)("ul",null,Object(r.b)("li",{parentName:"ul"},Object(r.b)("p",{parentName:"li"},Object(r.b)("inlineCode",{parentName:"p"},"delim::String")," : delimiter characters. The default (",Object(r.b)("inlineCode",{parentName:"p"},'"auto"'),") uses auto-parsing of ",Object(r.b)("inlineCode",{parentName:"p"},"CSV.File"))),Object(r.b)("li",{parentName:"ul"},Object(r.b)("p",{parentName:"li"},Object(r.b)("inlineCode",{parentName:"p"},"digits::Integer")," : the number of digits used to denote an allele (default: ",Object(r.b)("inlineCode",{parentName:"p"},"3"),")")),Object(r.b)("li",{parentName:"ul"},Object(r.b)("p",{parentName:"li"},Object(r.b)("inlineCode",{parentName:"p"},"diploid::Bool"),"  : whether samples are diploid for parsing optimizations (default: ",Object(r.b)("inlineCode",{parentName:"p"},"true"),")")),Object(r.b)("li",{parentName:"ul"},Object(r.b)("p",{parentName:"li"},Object(r.b)("inlineCode",{parentName:"p"},"silent::Bool")," : whether to print file information during import (default: ",Object(r.b)("inlineCode",{parentName:"p"},"true"),")"))),Object(r.b)("h2",{id:"formatting"},"Formatting"),Object(r.b)("ul",null,Object(r.b)("li",{parentName:"ul"},"First row is column names in this order:",Object(r.b)("ol",{parentName:"li"},Object(r.b)("li",{parentName:"ol"},"name"),Object(r.b)("li",{parentName:"ol"},"population"),Object(r.b)("li",{parentName:"ol"},"longitude"),Object(r.b)("li",{parentName:"ol"},"latitude"),Object(r.b)("li",{parentName:"ol"},"locus_1_name"),Object(r.b)("li",{parentName:"ol"},"locus_2_name"),Object(r.b)("li",{parentName:"ol"},"etc...")))),Object(r.b)("h3",{id:"missing-data"},"Missing data"),Object(r.b)("h4",{id:"genotypes"},"Genotypes"),Object(r.b)("p",null,"Missing genotypes can be formatted as all-zeros (ex.",Object(r.b)("inlineCode",{parentName:"p"},"000000"),") or negative-nine ",Object(r.b)("inlineCode",{parentName:"p"},"-9")),Object(r.b)("h4",{id:"location-data"},"Location data"),Object(r.b)("p",null,"If location data is missing for a sample (which is ok!), make sure the value is blank, otherwise there will be transcription errors! (example at line 3 in the example below)"),Object(r.b)("p",null,Object(r.b)("strong",{parentName:"p"},"Example")),Object(r.b)("pre",null,Object(r.b)("code",Object(a.a)({parentName:"pre"},{}),'lizardsCA = Read.delimited("CA_lizards.csv", digits = 3);\n')),Object(r.b)("h5",{id:"formatting-example"},"Formatting example:"),Object(r.b)("pre",null,Object(r.b)("code",Object(a.a)({parentName:"pre"},{}),"name,population,long,lat,Locus1,Locus2,Locus3   \\n\nsierra_01,mountain,11.11,-22.22,001001,002002,001001   \\n\nsierra_02,mountain,11.12,-22.21,001001,001001,001002   \\n\nsnbarb_01,coast,,,001001,001001,001002 \\n\nsnbarb_02,coast,11.14,-22.24,001001,001001,001001 \\n\nsnbarb_03,coast,11.15,,001002,001001,001001 \\n\n")),Object(r.b)("div",{className:"admonition admonition-info alert alert--info"},Object(r.b)("div",Object(a.a)({parentName:"div"},{className:"admonition-heading"}),Object(r.b)("h5",{parentName:"div"},Object(r.b)("span",Object(a.a)({parentName:"h5"},{className:"admonition-icon"}),Object(r.b)("svg",Object(a.a)({parentName:"span"},{xmlns:"http://www.w3.org/2000/svg",width:"14",height:"16",viewBox:"0 0 14 16"}),Object(r.b)("path",Object(a.a)({parentName:"svg"},{fillRule:"evenodd",d:"M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z"})))),"alias")),Object(r.b)("div",Object(a.a)({parentName:"div"},{className:"admonition-content"}),Object(r.b)("p",{parentName:"div"},"You can also use the command ",Object(r.b)("inlineCode",{parentName:"p"},"csv()")," synonymously with ",Object(r.b)("inlineCode",{parentName:"p"},"delimited()"),". "))),Object(r.b)("h2",{id:"acknowledgements"},"Acknowledgements"),Object(r.b)("p",null,"Thanks to the efforts of the ",Object(r.b)("a",Object(a.a)({parentName:"p"},{href:"https://github.com/JuliaData/CSV.jl"}),"CSV.jl")," team, we are able leverage that package to do much of the heavy lifting within this parser. "))}p.isMDXComponent=!0},155:function(e,t,n){"use strict";n.d(t,"a",(function(){return d})),n.d(t,"b",(function(){return u}));var a=n(0),i=n.n(a);function r(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){r(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function c(e,t){if(null==e)return{};var n,a,i=function(e,t){if(null==e)return{};var n,a,i={},r=Object.keys(e);for(a=0;a<r.length;a++)n=r[a],t.indexOf(n)>=0||(i[n]=e[n]);return i}(e,t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);for(a=0;a<r.length;a++)n=r[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(i[n]=e[n])}return i}var b=i.a.createContext({}),p=function(e){var t=i.a.useContext(b),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},d=function(e){var t=p(e.components);return i.a.createElement(b.Provider,{value:t},e.children)},m={inlineCode:"code",wrapper:function(e){var t=e.children;return i.a.createElement(i.a.Fragment,{},t)}},s=i.a.forwardRef((function(e,t){var n=e.components,a=e.mdxType,r=e.originalType,o=e.parentName,b=c(e,["components","mdxType","originalType","parentName"]),d=p(n),s=a,u=d["".concat(o,".").concat(s)]||d[s]||m[s]||r;return n?i.a.createElement(u,l(l({ref:t},b),{},{components:n})):i.a.createElement(u,l({ref:t},b))}));function u(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var r=n.length,o=new Array(r);o[0]=s;var l={};for(var c in t)hasOwnProperty.call(t,c)&&(l[c]=t[c]);l.originalType=e,l.mdxType="string"==typeof e?e:a,o[1]=l;for(var b=2;b<r;b++)o[b]=n[b];return i.a.createElement.apply(null,o)}return i.a.createElement.apply(null,n)}s.displayName="MDXCreateElement"}}]);