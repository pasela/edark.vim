" Vim color file
" Maintainer: Yuki <paselan at Gmail.com>
" URL: https://github.com/pasela/edark.vim
" Last Change: Mon, 02 Jul 2012 11:22:58 +0900
" Version: 0.1.8
"
" A dark color scheme for GUI and 256 colors CUI, inspired by the rdark color scheme.
" 
" Thanks to Radu Dineiu, the rdark author.
" (rdark http://www.vim.org/scripts/script.php?script_id=1732)
"
" Features:
"   - let edark_current_line = 1 if you want to highlight the current line
"   - let edark_ime_cursor = 1 if you want to highlight the cursor when IME on
"   - let edark_insert_status_line = 1 if you want to highlight the status line when insert-mode
"
" ToDo:
"   - Support InsertEnter/Leave on CUI
"
" Changelog:
"   0.1.8
"     - CHANGE 'diffFile', 'diffAdded', 'diffDeleted', 'diffChanged' color.
"
"   0.1.7
"     - ADD: 'CursorLineNr' color.
"
"   0.1.6
"     - CHANGE: 'NonText' color.
"     - CHANGE: 'DiffAdd', 'DiffDelete', 'DiffChange', 'DiffText' color.
"
"   0.1.5
"     - CHANGE: 'IncSearch' color.
"
"   0.1.4
"     - FIX: 'Visual' color.
"
"   0.1.3
"     - FIX: 'Search' hilight definition was wrong value.
"
"   0.1.2
"     - FIX: all options were ignored
"     - IMPROVE: support 88 and 256 CUI
"
"   0.1
"     - initial version

set background=dark

hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "edark"


if has("gui_running") || &t_Co == 88 || &t_Co == 256
    " functions {{{
    " returns an approximate grey index for the given grey level
    fun <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual grey level represented by the grey index
    fun <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " returns the palette index for the given grey index
    fun <SID>grey_color(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " returns an approximate color index for the given color level
    fun <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual color level for the given color index
    fun <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " returns the palette index for the given R/G/B color indices
    fun <SID>rgb_color(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " returns the palette index to approximate the given R/G/B color levels
    fun <SID>color(r, g, b)
        " get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " get the closest color
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " there are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " use the grey
                return <SID>grey_color(l:gx)
            else
                " use the color
                return <SID>rgb_color(l:x, l:y, l:z)
            endif
        else
            " only one possibility
            return <SID>rgb_color(l:x, l:y, l:z)
        endif
    endfun

    " returns the palette index to approximate the 'rrggbb' hex string
    fun <SID>rgb(rgb)
        if strlen(a:rgb) != 6
            return a:rgb
        endif
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>color(l:r, l:g, l:b)
    endfun

    " sets the highlighting for the given group
    fun <SID>X(group, fg, bg, attr)
        if a:fg != ""
            let l:fg = strlen(a:fg) == 6 ? "#" . a:fg : a:fg
            exec "hi " . a:group . " guifg=" . l:fg . " ctermfg=" . <SID>rgb(a:fg)
        endif
        if a:bg != ""
            let l:bg = strlen(a:bg) == 6 ? "#" . a:bg : a:bg
            exec "hi " . a:group . " guibg=" . l:bg . " ctermbg=" . <SID>rgb(a:bg)
        endif
        if a:attr != ""
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
    endfun
    " }}}

    " Current Line
    if exists('edark_current_line') && edark_current_line == 1
      set cursorline
      call <SID>X('CursorLine', '', '333333', '')
    endif
    call <SID>X('CursorLineNr', 'babdb6', '', 'none')

    " Default Colors
    call <SID>X('Normal', 'babdb6', '1e2426', '')
    "call <SID>X('NonText', '2c3032', '2c3032', 'none')
    call <SID>X('NonText', '505456', '2c3032', '')
    call <SID>X('Cursor', '', 'babdb6', '')
    call <SID>X('ICursor', '', 'babdb6', '')

    " IME Cursor
    if exists('edark_ime_cursor') && edark_ime_cursor == 1
      if has('multi_byte_ime') || has('xim')
        call <SID>X('CursorIM', 'NONE', '8ae234', '')
      endif
    endif

    " Search
    call <SID>X('Search', '2e3436', 'fcaf3e', '')
    call <SID>X('IncSearch', 'ff8060', '2e3436', '')

    " Window Elements
    call <SID>X('StatusLine', '2e3436', 'babdb6', 'none')
    call <SID>X('StatusLineNC', '2e3436', '888a85', 'none')
    call <SID>X('VertSplit', '555753', '888a85', 'none')
    call <SID>X('Visual', '', '333333', '')
    call <SID>X('MoreMsg', '729fcf', '', '')
    call <SID>X('Question', '8ae234', '', 'none')
    call <SID>X('WildMenu', 'eeeeec', '0e1416', '')
    call <SID>X('LineNr', '3f4b4d', '000000', '')
    call <SID>X('SignColumn', '', '1e2426', '')

    " Insert mode status line
    if exists('edark_insert_status_line') && edark_insert_status_line == 1
      augroup InsertHook
        autocmd!
        autocmd InsertEnter * exec "hi StatusLine guifg=#2e3436 guibg=#ccdc90"
        autocmd InsertLeave * exec "hi StatusLine guifg=#2e3436 guibg=#babdb6 gui=none"
      augroup END
    endif

    " Pmenu
    call <SID>X('Pmenu', 'eeeeec', '2e3436', '')
    call <SID>X('PmenuSel', '1e2426', 'ffffff', '')
    call <SID>X('PmenuSbar', '', '555753', '')
    call <SID>X('PmenuThumb', 'ffffff', '', '')

    " QuickFix
    call <SID>X('qfLineNr', '8ae234', '', '')

    " Diff
    "call <SID>X('DiffDelete', '2e3436', '0e1416', '')
    "call <SID>X('DiffAdd', '', '1f2b2d', '')
    "call <SID>X('DiffChange', '', '2e3436', '')
    "call <SID>X('DiffText', '', '000000', 'none')
    call <SID>X('DiffDelete', 'afafaf', '4e3437', 'none')
    call <SID>X('DiffAdd', 'afafaf', '30493b', 'none')
    call <SID>X('DiffChange', 'afafaf', '54573b', 'none')
    call <SID>X('DiffText', 'cfcfcf', '727750', 'none')

    " Folds
    call <SID>X('Folded', 'd3d7cf', '204a87', '')
    call <SID>X('FoldColumn', '3465a4', '000000', '')

    " Specials
    call <SID>X('Title', 'fcaf3e', '', '')
    call <SID>X('Todo', 'fcaf3e', 'bg', '')
    call <SID>X('SpecialKey', 'ad7fa8', '', '')

    " Tabs
    call <SID>X('TabLine', '888a85', '0a1012', '')
    call <SID>X('TabLineFill', '0a1012', '', '')
    call <SID>X('TabLineSel', 'eeeeec', '555753', 'none')

    " Matches
    call <SID>X('MatchParen', '2e3436', '906090', '')

    " Tree
    call <SID>X('Directory', 'ffffff', '', '')

    " Syntax
    call <SID>X('Comment', '809090', '', '')
    call <SID>X('Constant', '8ae234', '', '')
    call <SID>X('Number', '8ae234', '', '')
    call <SID>X('Statement', '729fcf', '', 'none')
    call <SID>X('Identifier', 'ffffff', '', '')
    call <SID>X('PreProc', 'fcaf3e', '', '')
    call <SID>X('Function', 'fcaf3e', '', '')
    call <SID>X('Type', 'e3e7df', '', 'none')
    call <SID>X('Keyword', 'eeeeec', '', '')
    call <SID>X('Special', '888a85', '', '')
    call <SID>X('Error', 'eeeeec', 'cc0000', '')
    call <SID>X('', '', '', '')

    " PHP
    call <SID>X('phpRegionDelimiter', 'ad7fa8', '', '')
    call <SID>X('phpPropertySelector', '888a85', '', '')
    call <SID>X('phpPropertySelectorInString', '888a85', '', '')
    call <SID>X('phpOperator', '888a85', '', '')
    call <SID>X('phpArrayPair', '888a85', '', '')
    call <SID>X('phpAssignByRef', '888a85', '', '')
    call <SID>X('phpRelation', '888a85', '', '')
    call <SID>X('phpMemberSelector', '888a85', '', '')
    call <SID>X('phpUnknownSelector', '888a85', '', '')
    call <SID>X('phpVarSelector', 'babdb6', '', '')
    call <SID>X('phpSemicolon', '888a85', '', 'none')
    call <SID>X('phpFunctions', 'd3d7cf', '', '')
    call <SID>X('phpParent', '888a85', '', '')

    " JavaScript
    call <SID>X('javaScriptBraces', '888a85', '', '')
    call <SID>X('javaScriptOperator', '888a85', '', '')

    " HTML
    call <SID>X('htmlTag', '888a85', '', '')
    call <SID>X('htmlEndTag', '888a85', '', '')
    call <SID>X('htmlTagName', 'babdb6', '', '')
    call <SID>X('htmlSpecialTagName', 'babdb6', '', '')
    call <SID>X('htmlArg', 'd3d7cf', '', '')
    call <SID>X('htmlTitle', '8ae234', '', 'none')
    hi link htmlH1 htmlTitle
    hi link htmlH2 htmlH1
    hi link htmlH3 htmlH1
    hi link htmlH4 htmlH1
    hi link htmlH5 htmlH1
    hi link htmlH6 htmlH1

    " XML
    hi link xmlTag htmlTag
    hi link xmlEndTag htmlEndTag
    hi link xmlAttrib htmlArg

    " CSS
    call <SID>X('cssSelectorOp', 'eeeeec', '', '')
    hi link cssSelectorOp2 cssSelectorOp
    call <SID>X('cssUIProp', 'd3d7cf', '', '')
    hi link cssPagingProp cssUIProp
    hi link cssGeneratedContentProp cssUIProp
    hi link cssRenderProp cssUIProp
    hi link cssBoxProp cssUIProp
    hi link cssTextProp cssUIProp
    hi link cssColorProp cssUIProp
    hi link cssFontProp cssUIProp
    call <SID>X('cssPseudoClassId', 'eeeeec', '', '')
    call <SID>X('cssBraces', '888a85', '', '')
    call <SID>X('cssIdentifier', 'fcaf3e', '', '')
    call <SID>X('cssTagName', 'fcaf3e', '', '')
    hi link cssInclude Function
    hi link cssCommonAttr Constant
    hi link cssUIAttr Constant
    hi link cssTableAttr Constant
    hi link cssPagingAttr Constant
    hi link cssGeneratedContentAttr Constant
    hi link cssAuralAttr Constant
    hi link cssRenderAttr Constant
    hi link cssBoxAttr Constant
    hi link cssTextAttr Constant
    hi link cssColorAttr Constant
    hi link cssFontAttr Constant

    " diff
    hi link diffFile Title
    hi link diffAdded DiffAdd
    hi link diffRemoved DiffDelete
    hi link diffChanged DiffChange

    " delete functions {{{
    delf <SID>X
    delf <SID>rgb
    delf <SID>color
    delf <SID>rgb_color
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_color
    delf <SID>grey_level
    delf <SID>grey_number
    " }}}
endif
