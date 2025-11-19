<style>
    .colorbox {
        display:inline-block;
        width:20px;
        height:20px;
        border:1px solid rgba(128,128,128,1);
        background-color: var(--boxcolor, #808080);
    }
</style>

Changing the IG colors can be done by manipulating the css variables, e.g. by overriding the color definition variables.


<div xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.w3.org/1999/xhtml ../../schema/fhir-xhtml.xsd" xmlns="http://www.w3.org/1999/xhtml">
<blockquote class="stu-note">
	<strong>This note (styled 'stu-note') contains a warning message.</strong>
	This message may be used to draw the readers' attention to some points, e.g. to request feedback, or be aware of any constraints, or disclaimers.
</blockquote>
</div>

<p class="dragon">This box (styled 'dragon') serves to warn about issues or pitfalls</p>



### Color overview
The colors that can be identified are:

<span style="font-weight:bold; color:#ff0000">1. </span> IG Title and status text color  
<span style="font-weight:bold; color:#800080">2. </span> Header container color  
<span style="font-weight:bold; color:#808080">3. </span> Footer background color  
<span style="font-weight:bold; color:#0000ff">4. </span> Footer container color  
<span style="font-weight:bold; color:#00ff00">5. </span> Header strip color   
<span style="font-weight:bold; color:#000080">6. </span> Menu button hover color  
<span style="font-weight:bold; color:#006400">7. </span> Menu button active color  
<span style="font-weight:bold; color:#ff00ff">8. </span> Menu button text color   
<span style="font-weight:bold; color:#87ceeb">9. </span> Menu item gradient start color  
<span style="font-weight:bold; color:#f0e68c">10. </span> Menu item gradient end  color  
<span style="font-weight:bold; color:#d2b48c">11. </span> Menu item gradient start color (with alpha)  
<span style="font-weight:bold; color:#fa8072">12. </span> Menu item gradient end color (with alpha)  
<span style="font-weight:bold; color:#2f4f4f">13. </span> [Hyperlink text color](index.html)   
<span style="font-weight:bold; color:#8b0000">14. </span> [Hyperlink text hover color](index.html)  
<span style="font-weight:bold; color:#ffff00">15. </span> Publish box background color  
<span style="font-weight:bold; color:#ff4500">16. </span> Publish box border definition  
<span style="font-weight:bold; color:#98fb98">17. </span> TOC box background color  
<span style="font-weight:bold; color:#2e8b57">18. </span> TOC box border definition  
<span style="font-weight:bold; color:#8b4513">19. </span> (STU) Note box background color  
<span style="font-weight:bold; color:#ffa0ff">20. </span> (STU) Note box border color  
<span style="font-weight:bold; color:#fff2ff">21. </span> Header color (sides)  
<span style="font-weight:bold; color:#4b0082">22. </span> Header container color (center)  

<span style="font-weight:bold; color:#f5f5f5">23. </span> Footer navigation background color  
<span style="font-weight:bold; color:#777777">24. </span> Footer highlight font color  
<span style="font-weight:bold; color:#800000">25. </span> Footer hyperlinks font color  
<span style="font-weight:bold; color:#ffff77">26. </span> Footer highlight font color  
<span style="font-weight:bold; color:#506070">27. </span> Breadcrumb background color  
<span style="font-weight:bold; color:#302010">28. </span> Breadcrumb font color  
<span style="font-weight:bold; color:#ebe7ee">29. </span> Dragon background color  
<span style="font-weight:bold; color:#400070">30. </span> Dragon font color  





These colors are shown in the image below:

<img src="{{site.baseurl}}colors.png" alt="IG Colors" style="width: 100%;"/>
<br clear="all"/>

### CSS color definitions
To change the colors, simply override (by adding a new CSS) the values of the colors. The example values below change the colors to those illustrated in the picture above.

```css
:root {
    --ig-status-text-color: #ff0000; /* 1. IG Title and status text color */
    --navbar-bg-color: #800080; /* 2. Header container color */
    --footer-bg-color: #808080; /* 3. Footer background color*/
    --footer-container-bg-color: #0000ff; /* 4. Footer container color */
    --stripe-bg-color: #00ff00; /* 5. Header strip color */
    --btn-hover-color: #000080;  /* 6. Menu button hover color */
    --btn-active-color: #006400; /* 7. Menu button active color */
    --btn-text-color: #ff00ff; /* 8. Menu button text color */
    --btn-gradient-start-color: #87ceeb; /* 9. Menu item gradient start color */
    --btn-gradient-end-color: #f0e68c; /* 10. Menu item gradient end  color */
    --btn-gradient-start-color-alpha: #d2b48c; /* 11. Menu item gradient start color (with alpha) */
    --btn-gradient-end-color-alpha: #fa8072; /* 12. Menu item gradient end color (with alpha) */
    --link-color: #2f4f4f; /* 13. Hyperlink text color */
    --link-hover-color: #8b0000; /* 14. Hyperlink text hover color */
    --publish-box-bg-color: #ffff00; /* 15. Publish box background color */
    --publish-box-border: 1px solid #ff4500; /* 16.  Publish box border definition */
    --toc-box-bg-color: #98fb98; /* 17.  TOC box background color */
    --toc-box-border: 1px solid #2e8b57; /* 18. TOC box border definition */
    --stu-note-background-color: #8b4513; /* 19. (STU) Note box background color */
    --stu-note-border-left-color: #ffa0ff; /* 20. (STU) Note box border color */
    --ig-header-color: #fff2ff; /* 21. Header color (sides) */
    --ig-header-container-color: #4b0082; /* 22. Header container color (center) */
    --footer-nav-bg-color: #f5f5f5; /* 23. Footer navigation background color*/
    --footer-text-color: #777777; /* 24. Footer highlight font color */
    --footer-hyperlink-text-color: #800000; /* 25. Footer hyperlinks font color */
    --footer-highlight-text-color: #ffff77; /* 26. Footer highlight font color */
    --breadcrumb-bg-color: #506070  ; /* 27. Breadcrumb background color */
    --breadcrumb-text-color: #302010; /* 28. Breadcrumb font color */
    --dragon-background-color: #ebe7ee; /* 29. Dragon background color */
    --dragon-font-color: #400070; /* 30. Dragon font color */
}
```

### Tabular Representation

The defined style colors are listed below. Numbers beside element correspond to the diagram above. The color swatches correspond to the style of *this* implementation guide (not the diagram, or list above).

#### Text elements

| Element | Text | Background | Border | Link | Hover |
|---|---|---|---|---|---|
| Header | <span class="colorbox" style="--boxcolor: var(--ig-status-text-color);"></span> `--ig-status-text-color` (1) | <span class="colorbox" style="--boxcolor: var(--ig-header-container-color);"></span> `--ig-header-container-color` (22)| | | |
| Breadcrumb | <span class="colorbox" style="--boxcolor: var(--breadcrumb-text-color);"></span> `--breadcrumb-text-color` (27) | <span class="colorbox" style="--boxcolor: var(--breadcrumb-bg-color);"></span> `--breadcrumb-bg-color` (28) | | | |
| Body | | | | <span class="colorbox" style="--boxcolor: var(--link-color);"></span> `--link-color` (13) | <span class="colorbox" style="--boxcolor: var(--link-hover-color);"></span> `--link-hover-color` (14) |
| Footer nav bar | | <span class="colorbox" style="--boxcolor: var(--footer-nav-bg-color);"></span> `--footer-nav-bg-color` (23) | | | |
| Footer body | <span class="colorbox" style="--boxcolor: var(--footer-text-color);"></span> `--footer-text-color` (24)<br> <span class="colorbox" style="--boxcolor: var(--footer-highlight-text-color);"></span> `--footer-highlight-text-color` (26) | <span class="colorbox" style="--boxcolor: var(--footer-container-bg-color);"></span> `--footer-container-bg-color` (4) | | <span class="colorbox" style="--boxcolor: var(--footer-hyperlink-text-color);"></span> `--footer-hyperlink-text-color` (25) | |
| ToC Box | | <span class="colorbox" style="--boxcolor: var(--toc-box-bg-color);"></span> `--toc-box-bg-color` (17) | see [boxes](#boxes) below | | |
| Publish  | | <span class="colorbox" style="--boxcolor: var(--publish-box-bg-color);"></span> `--publish-box-bg-color` (15) | see [boxes](#boxes) below | | |
| Dragon Note | <span class="colorbox" style="--boxcolor: var(--dragon-font-color);"></span> `--dragon-font-color` (29) | <span class="colorbox" style="--boxcolor: var(--dragon-background-color);"></span> `--dragon-background-color` (30) | | | |
| STU Note | | <span class="colorbox" style="--boxcolor: var(--stu-note-background-color);"></span> `--stu-note-background-color` (19) | <span class="colorbox" style="--boxcolor: var(--stu-note-border-left-color);"></span> `--stu-note-border-left-color` (20) | | |

##### Boxes

The style of certain elements are defined by more than just color ():

<p style="border:var(--publish-box-border);" markdown="1">`--publish-box-border` (16)</p>
<p style="border:var(--toc-box-border);" markdown="1">`--toc-box-border` (18)</p>

#### Side Decoration

| Element | Background | Highlight |
|---|---|---|
| Header | <span class="colorbox" style="--boxcolor: var(--ig-header-color);"></span> `--ig-header-color` (21) | <span class="colorbox" style="--boxcolor: var(--stripe-bg-color);"></span> `--stripe-bg-color` (5) |
| Footer | <span class="colorbox" style="--boxcolor: var(--footer-bg-color);"></span> `--footer-bg-color` (3) | |

#### Menus

##### Menu bar

| Element | Text | Background | Hover | Open |
|---|---|---|---|---|
| Menu Bar | <span class="colorbox" style="--boxcolor: var(--btn-text-color);"></span> `--btn-text-color` (8) | <span class="colorbox" style="--boxcolor: var(--navbar-bg-color);"></span> `--navbar-bg-color` (2) | <span class="colorbox" style="--boxcolor: var(--btn-hover-color);"></span> `--btn-hover-color` (6) | <span class="colorbox" style="--boxcolor: var(--btn-active-color);"></span> `--btn-active-color` (7) |

##### Dropdown

| Element | Background Start | Background End |
| Gradient | <span class="colorbox" style="--boxcolor: var(--btn-gradient-start-color);"></span> `--btn-gradient-start-color` (9) | <span class="colorbox" style="--boxcolor: var(--btn-gradient-end-color);"></span> `--btn-gradient-end-color` (10) |
| Gradient Alpha | <span class="colorbox" style="--boxcolor: var(--btn-gradient-start-color-alpha);"></span> `--btn-gradient-start-color-alpha` (11) | <span class="colorbox" style="--boxcolor: var(--btn-gradient-end-color-alpha);"></span> `--btn-gradient-end-color-alpha` (12) |

#### Other elements

For consistency, the styling of the "content" including hierarchy trees, element definitions, and most narrative, don't use color variables: Text is dark grey on a white background. Other content, such as code blocks, have their own defined styles.

The "stats blocks" at the top of definitional resource pages showing canonical URL, name, etc. do not use color variables, but are defined in the following table styles:

* `colsd` for draft
* `colstu` for trial use
* `colsn` for normative
* `colsi` for informative
* `coldp` for deprecated
* `colse` for external
