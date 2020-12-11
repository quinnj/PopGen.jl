(window.webpackJsonp=window.webpackJsonp||[]).push([[58],{129:function(e,t,n){"use strict";n.r(t),n.d(t,"frontMatter",(function(){return i})),n.d(t,"metadata",(function(){return c})),n.d(t,"rightToc",(function(){return p})),n.d(t,"default",(function(){return l}));var r=n(3),o=n(7),a=(n(0),n(144)),i={id:"api",title:"API",sidebar_label:"API"},c={unversionedId:"api/api",id:"api/api",isDocsHomePage:!1,title:"API",description:"These pages contains the APIs, or Application Programming Interface, which are the entirety of all the functions/commands available in PopGen.jl. Unlike other sections of these docs, these pages are intended to be technical rather than a guide. Included here are the function definitions and their docstrings as they appear inside this package. Most of these functions are used under-the-hood and not exported, meaning that if you want to use them, you will need to invoke them with PopGen.function. For example, if you wanted to use uniquealleles (which is not exported), you can do so with PopGen.uniquealleles().",source:"@site/docs/api/API.md",slug:"/api/api",permalink:"/PopGen.jl/docs/api/api",editUrl:"https://github.com/pdimens/popgen.jl/edit/documentation/docs/api/API.md",version:"current",lastUpdatedAt:1591241785,sidebar_label:"API",sidebar:"docs",previous:{title:"Simulate Sibling Pairs",permalink:"/PopGen.jl/docs/simulations/sibship_simulations"},next:{title:"AlleleFreq.jl",permalink:"/PopGen.jl/docs/api/allelefreq"}},p=[],s={rightToc:p};function l(e){var t=e.components,n=Object(o.a)(e,["components"]);return Object(a.b)("wrapper",Object(r.a)({},s,n,{components:t,mdxType:"MDXLayout"}),Object(a.b)("p",null,"These pages contains the APIs, or ",Object(a.b)("strong",{parentName:"p"},"A"),"pplication ",Object(a.b)("strong",{parentName:"p"},"P"),"rogramming ",Object(a.b)("strong",{parentName:"p"},"I"),"nterface, which are the entirety of all the functions/commands available in PopGen.jl. Unlike other sections of these docs, these pages are intended to be ",Object(a.b)("em",{parentName:"p"},"technical")," rather than a guide. Included here are the function definitions and their docstrings as they appear inside this package. Most of these functions are used under-the-hood and not exported, meaning that if you want to use them, you will need to invoke them with ",Object(a.b)("inlineCode",{parentName:"p"},"PopGen.function"),". For example, if you wanted to use ",Object(a.b)("inlineCode",{parentName:"p"},"unique_alleles")," (which is not exported), you can do so with ",Object(a.b)("inlineCode",{parentName:"p"},"PopGen.unique_alleles()"),". "))}l.isMDXComponent=!0},144:function(e,t,n){"use strict";n.d(t,"a",(function(){return u})),n.d(t,"b",(function(){return h}));var r=n(0),o=n.n(r);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function c(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function p(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},a=Object.keys(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var s=o.a.createContext({}),l=function(e){var t=o.a.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):c(c({},t),e)),n},u=function(e){var t=l(e.components);return o.a.createElement(s.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return o.a.createElement(o.a.Fragment,{},t)}},f=o.a.forwardRef((function(e,t){var n=e.components,r=e.mdxType,a=e.originalType,i=e.parentName,s=p(e,["components","mdxType","originalType","parentName"]),u=l(n),f=r,h=u["".concat(i,".").concat(f)]||u[f]||d[f]||a;return n?o.a.createElement(h,c(c({ref:t},s),{},{components:n})):o.a.createElement(h,c({ref:t},s))}));function h(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var a=n.length,i=new Array(a);i[0]=f;var c={};for(var p in t)hasOwnProperty.call(t,p)&&(c[p]=t[p]);c.originalType=e,c.mdxType="string"==typeof e?e:r,i[1]=c;for(var s=2;s<a;s++)i[s]=n[s];return o.a.createElement.apply(null,i)}return o.a.createElement.apply(null,n)}f.displayName="MDXCreateElement"}}]);