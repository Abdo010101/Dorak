"""Builds design/mockups/mockups.html — دورك UI mockups (Arabic RTL + English LTR).

Run:  python build.py   then export to PDF with headless Chrome (see README in design/).
Visual tokens come from design/design-tokens.md (Figma Design System); anything
not in the Design System is rendered with a PROPOSED tag.
"""
import html
import pathlib
import re

ROOT = pathlib.Path(__file__).parent
ICONS = ROOT / "icons"


# ---------------------------------------------------------------- icons
def icon(name, size=20, color="currentColor", cls=""):
    raw = (ICONS / f"{name}.svg").read_text(encoding="utf-8")
    w = float(re.search(r'width="([\d.]+)"', raw).group(1))
    h = float(re.search(r'height="([\d.]+)"', raw).group(1))
    inner = re.sub(r"^.*?<svg[^>]*>", "", raw, flags=re.S).rsplit("</svg>", 1)[0]
    # Figma exports glyphs in #010101 (linear set) or white (social set)
    inner = inner.replace("#010101", "currentColor").replace('fill="white"', 'fill="currentColor"')
    box = max(24.0, w, h)
    tx, ty = (box - w) / 2, (box - h) / 2
    return (
        f'<svg class="ic {cls}" width="{size}" height="{size}" viewBox="0 0 {box} {box}" fill="none" '
        f'style="color:{color}" aria-hidden="true"><g transform="translate({tx},{ty})">{inner}</g></svg>'
    )


# ---------------------------------------------------------------- copy
T = {
    "ar": dict(
        cur_loc="موقعك الحالي", picked_loc="الموقع المختار", loc_val="الرياض، حي النرجس",
        loc_manual_val="جدة، حي الروضة", set_loc="حدّد موقعك", resolving="جارٍ تحديد موقعك…",
        specialties="التخصصات الطبية", all="الكل", nearby="المراكز الطبية القريبة منك",
        sp=["الأسنان", "الجلدية", "العيون", "الأطفال", "النساء والولادة"],
        km="كم", doctors="أطباء", change_loc="تغيير الموقع",
    ),
    "en": dict(
        cur_loc="Your current location", picked_loc="Selected location", loc_val="Riyadh, Al Narjis",
        loc_manual_val="Jeddah, Al Rawdah", set_loc="Set your location", resolving="Finding your location…",
        specialties="Medical specialties", all="All", nearby="Medical centers near you",
        sp=["Dentistry", "Dermatology", "Ophthalmology", "Pediatrics", "OB/GYN"],
        km="km", doctors="doctors", change_loc="Change location",
    ),
}

CENTERS = {
    "ar": [
        dict(name="مركز النخبة الطبي", sp="الأسنان", city="الرياض", addr="حي النرجس، طريق أنس بن مالك",
             dist="2.4", desc="مركز متخصص في علاج وتجميل الأسنان، ويضم عيادات مجهزة لجميع الفئات العمرية.",
             docs="8", phone="011 234 5678", img="center-dental.jpg"),
        dict(name="مجمع الشفاء الطبي", sp="الجلدية · الأطفال", city="الرياض", addr="حي الياسمين، شارع الثمامة",
             dist="3.1", desc="مجمع طبي يقدم خدمات الجلدية وطب الأطفال بإشراف استشاريين.",
             docs="14", phone="011 456 7890", img="center-complex.jpg"),
        dict(name="مركز رعاية العيون التخصصي", sp="العيون", city="الرياض", addr="حي الملقا، طريق الملك فهد",
             dist="4.8", desc="فحوصات النظر وعلاج أمراض العيون وجراحات الليزر.",
             docs="5", phone="011 987 6543", img="center-eye.jpg"),
    ],
    "en": [
        dict(name="Al Nokhba Medical Center", sp="Dentistry", city="Riyadh", addr="Al Narjis, Anas Ibn Malik Rd",
             dist="2.4", desc="A center specialized in restorative and cosmetic dentistry, with clinics for all ages.",
             docs="8", phone="011 234 5678", img="center-dental.jpg"),
        dict(name="Al Shifa Medical Complex", sp="Dermatology · Pediatrics", city="Riyadh", addr="Al Yasmin, Al Thumamah St",
             dist="3.1", desc="A medical complex offering dermatology and pediatrics led by consultants.",
             docs="14", phone="011 456 7890", img="center-complex.jpg"),
        dict(name="Eye Care Specialist Center", sp="Ophthalmology", city="Riyadh", addr="Al Malqa, King Fahd Rd",
             dist="4.8", desc="Vision tests, eye disease treatment and laser surgery.",
             docs="5", phone="011 987 6543", img="center-eye.jpg"),
    ],
}

e = html.escape


# ---------------------------------------------------------------- components
def status_bar():
    # status bar removed from mockups; keep only the top safe-area spacing
    return '<div class="safe-top"></div>'


def phone(body, lang="ar", footer="", cls=""):
    d = "rtl" if lang == "ar" else "ltr"
    return (f'<div class="phone {cls}" dir="{d}" lang="{lang}">{status_bar()}'
            f'<div class="screen">{body}</div>{footer}<div class="home-ind"></div></div>')


def topbar(title="", lang="ar"):
    # back chevron points toward the reading start: right in RTL, left in LTR
    flip = "flip" if lang == "ar" else ""
    t = f'<span class="tb-title">{e(title)}</span>' if title else ""
    return f'<div class="topbar"><button class="icon-btn" aria-label="back">{icon("chevron-left", 24, cls=flip)}</button>{t}</div>'


def btn(label, kind="primary", ic=None, loading=False, disabled=False, full=True):
    cls = f"btn btn-{kind}" + (" full" if full else "") + (" disabled" if disabled else "")
    inner = '<span class="spinner"></span>' if loading else ""
    if ic:
        inner += ic
    inner += f"<span>{e(label)}</span>"
    return f'<button class="{cls}">{inner}</button>'


def link(label, ic=None):
    return f'<button class="link">{ic or ""}<span>{e(label)}</span></button>'


def field_mobile(value="", state="default", label="رقم الجوال", helper="", placeholder="5X XXX XXXX", disabled=False):
    v = f'<span class="val">{e(value)}</span>' if value else f'<span class="ph">{e(placeholder)}</span>'
    caret = '<span class="caret"></span>' if state == "focused" else ""
    h = f'<div class="helper {state}">{e(helper)}</div>' if helper else ""
    return (f'<div class="fld"><div class="fld-label">{e(label)}</div>'
            f'<div class="fld-box mobile {state}{" dis" if disabled else ""}" dir="ltr"><span class="cc">+966</span>{v}{caret}</div>{h}</div>')


def field_text(label, value, state="default", helper="", dir_=None):
    d = f' dir="{dir_}"' if dir_ else ""
    h = f'<div class="helper {state}">{e(helper)}</div>' if helper else ""
    return (f'<div class="fld"><div class="fld-label">{e(label)}</div>'
            f'<div class="fld-box {state}"{d}><span class="val">{e(value)}</span></div>{h}</div>')


def otp(digits="", state="default", focus_idx=None):
    cells = []
    for i in range(4):
        ch = digits[i] if i < len(digits) else ""
        st = state
        if state == "default" and focus_idx == i:
            st = "focused"
        caret = '<span class="caret"></span>' if (focus_idx == i and not ch) else ""
        cells.append(f'<div class="otp-cell {st}">{e(ch)}{caret}</div>')
    return f'<div class="otp" dir="ltr">{"".join(cells)}</div>'


def banner(text, kind="error", ic="danger-circle"):
    return f'<div class="banner {kind}">{icon(ic, 20)}<span>{e(text)}</span></div>'


def loc_header(lang, mode="resolved"):
    t = T[lang]
    if mode == "resolving":
        body = (f'<div class="lh-text"><div class="lh-label">{e(t["cur_loc"])}</div>'
                f'<div class="lh-val muted"><span class="spinner sm dark"></span>{e(t["resolving"])}</div></div>')
    elif mode == "unset":
        body = (f'<div class="lh-text"><div class="lh-label">{e(t["cur_loc"])}</div>'
                f'<div class="lh-val">{e(t["set_loc"])}</div></div>')
    elif mode == "manual":
        body = (f'<div class="lh-text"><div class="lh-label">{e(t["picked_loc"])}</div>'
                f'<div class="lh-val">{e(t["loc_manual_val"])}</div></div>')
    else:
        body = (f'<div class="lh-text"><div class="lh-label">{e(t["cur_loc"])}</div>'
                f'<div class="lh-val">{e(t["loc_val"])}</div></div>')
    pin = "location-cross" if mode == "unset" else "location"
    return (f'<button class="loc-header"><span class="lh-pin">{icon(pin, 20)}</span>{body}'
            f'<span class="lh-chev">{icon("chevron-down", 20)}</span></button>')


def chips(lang, selected=0, mode="ok"):
    t = T[lang]
    head = f'<div class="sec-head"><h3>{e(t["specialties"])}</h3></div>'
    if mode == "loading":
        row = "".join(f'<span class="sk chip-sk" style="width:{w}px"></span>' for w in (52, 78, 70, 64, 84))
        return head + f'<div class="chips">{row}</div>'
    if mode == "failed":
        msg = "تعذّر تحميل التخصصات." if lang == "ar" else "Couldn't load specialties."
        rt = "إعادة المحاولة" if lang == "ar" else "Retry"
        return head + (f'<div class="chips"><span class="chip sel">{e(t["all"])}</span>'
                       f'<span class="inline-err">{icon("danger-circle", 16)}{e(msg)} {link(rt)}</span></div>')
    labels = [t["all"]] + t["sp"]
    row = "".join(f'<span class="chip{" sel" if i == selected else ""}">{e(l)}</span>' for i, l in enumerate(labels))
    return head + f'<div class="chips">{row}</div>'


def card(c, lang, compact=True):
    """Center card: cover image (distance on top) → name → specialty tags → address → excerpt → doctors + call."""
    t = T[lang]
    dist = (f'<span class="cv-dist">{icon("location", 14)}<span>{e(c["dist"])} {t["km"]}</span></span>'
            if c.get("dist") else "")
    cover = (f'<div class="cv photo" style="background-image:url(images/{c["img"]})">{dist}</div>' if c.get("img")
             else f'<div class="cv fallback">{icon("category", 32, "#A3A3A3")}{dist}</div>')
    tags = "".join(f'<span class="sp-tag">{e(s)}</span>' for s in c["sp"].split(" · "))
    desc = f'<p class="c-desc">{e(c["desc"])}</p>' if c.get("desc") else ""
    docs = (f'<span class="c-docs"><span class="c-docs-ic">{icon("group", 16)}</span>'
            f'<span><b>{e(c["docs"])}</b> {t["doctors"]}</span></span>' if c.get("docs") else "<span></span>")
    call = (f'<button class="c-call">{icon("call", 16)}<span dir="ltr">{e(c["phone"])}</span></button>'
            if c.get("phone") else "")
    foot = f'<div class="c-foot">{docs}{call}</div>' if (c.get("docs") or c.get("phone")) else ""
    return (f'<article class="card">{cover}<div class="c-body">'
            f'<h4 class="c-name">{e(c["name"])}</h4><div class="sp-tags">{tags}</div>'
            f'<div class="c-addr">{icon("location", 16)}<span>{e(c["city"])} · {e(c["addr"])}</span></div>'
            f'{desc}{foot}</div></article>')


def card_skeleton():
    return ('<article class="card"><div class="cv sk"></div><div class="c-body">'
            '<span class="sk line" style="width:65%"></span><span class="sk line sm" style="width:30%"></span>'
            '<span class="sk line sm" style="width:85%"></span><span class="sk line sm" style="width:55%"></span>'
            '</div></article>')


def results_head(lang):
    return f'<div class="sec-head"><h3>{e(T[lang]["nearby"])}</h3></div>'


def state_block(ic, title, text, primary=None, secondary=None, tone="neutral"):
    b = ""
    if primary:
        b += btn(primary[0], "primary", primary[1] if len(primary) > 1 else None)
    if secondary:
        b += btn(secondary, "secondary")
    return (f'<div class="state {tone}"><div class="state-ic">{icon(ic, 28)}</div>'
            f'<h3>{e(title)}</h3><p>{e(text)}</p><div class="state-btns">{b}</div></div>')


NAV = {
    "ar": [("home", "الرئيسية"), ("calendar", "المواعيد"), ("discount", "العروض"), ("setting", "الإعدادات")],
    "en": [("home", "Home"), ("calendar", "Appointments"), ("discount", "Offers"), ("setting", "Settings")],
}


def bottom_nav(lang="ar", active=0):
    items = "".join(f'<button class="bn-item{" on" if i == active else ""}">{icon(ic, 24)}<span>{e(l)}</span></button>'
                    for i, (ic, l) in enumerate(NAV[lang]))
    return f'<nav class="bottom-nav">{items}</nav>'


def home(lang="ar", loc="resolved", spec_mode="ok", selected=0, results="list", centers=None, state=None):
    body = '<div class="home">' + loc_header(lang, loc) + chips(lang, selected, spec_mode)
    if state:
        body += state
    else:
        body += results_head(lang)
        if results == "skeleton":
            body += card_skeleton() * 3
        else:
            for c in (centers if centers is not None else CENTERS[lang]):
                body += card(c, lang)
    body += "</div>"
    return phone(body, lang, footer=bottom_nav(lang))


# ---------------------------------------------------------------- screens: auth
def logo(size="lg", on_dark=False):
    return f'<img class="logo {size}{" dark" if on_dark else ""}" src="brand/logo.png" alt="دورك">'


def splash():
    body = (f'<div class="splash">{logo("xl")}'
            f'<div class="splash-load"><span class="spinner dark lg"></span></div></div>')
    return phone(body, "ar")


def auth_entry(lang="ar", overlay=None, notice=None):
    ar = lang == "ar"
    head = "أهلًا بك في دورك" if ar else "Welcome to دورك"
    sub = "سجّل الدخول أو أنشئ حسابًا للمتابعة." if ar else "Sign in or create an account to continue."
    phone_l = "المتابعة برقم الجوال" if ar else "Continue with phone number"
    apple_l = "المتابعة باستخدام Apple" if ar else "Continue with Apple"
    google_l = "المتابعة باستخدام Google" if ar else "Continue with Google"
    guest = "المتابعة كزائر" if ar else "Continue as guest"
    n = notice or ""
    body = (f'<div class="auth">{topbar("", lang)}<div class="auth-brand">{logo("md")}</div>'
            f'<h1 class="display">{e(head)}</h1><p class="lead">{e(sub)}</p>{n}'
            f'<div class="auth-btns">{btn(phone_l, "primary", icon("call", 20))}'
            f'<div class="divider"><span>{"أو" if ar else "or"}</span></div>'
            f'{btn(apple_l, "apple", icon("apple", 20, "#fff"))}'
            f'{btn(google_l, "google", icon("google", 20, "#1D1D1D"))}</div>'
            f'<div class="auth-foot">{link(guest)}</div></div>')
    if overlay:
        body += f'<div class="overlay"><div class="ov-card"><span class="spinner dark lg"></span><p>{e(overlay)}</p></div></div>'
    return phone(body, lang)


def phone_entry(value="", state="default", helper="", btn_state="enabled", top_banner=None):
    body = (f'<div class="form">{topbar("", "ar")}<h1 class="title">أدخل رقم جوالك</h1>'
            f'<p class="lead">سنرسل لك رمز تحقق في رسالة نصية.</p>'
            f'{top_banner or ""}{field_mobile(value, state, helper=helper, disabled=btn_state == "loading")}'
            f'<div class="grow"></div>'
            f'{btn("إرسال رمز التحقق", "primary", loading=btn_state == "loading", disabled=btn_state == "disabled")}</div>')
    return phone(body, "ar")


def otp_screen(digits="", state="default", focus=None, resend="countdown", msg="", btn_state="disabled", top_banner=None):
    rs = {
        "countdown": '<p class="resend">إعادة إرسال الرمز بعد <bdi dir="ltr"><b>00:45</b></bdi></p>',
        "available": f'<p class="resend">لم يصلك الرمز؟ {link("إعادة إرسال الرمز")}</p>',
        "locked": '<p class="resend muted">إعادة الإرسال غير متاحة حاليًا</p>',
    }[resend]
    helper = f'<div class="helper {state}">{e(msg)}</div>' if msg else ""
    body = (f'<div class="form">{topbar("", "ar")}<h1 class="title">أدخل رمز التحقق</h1>'
            f'<p class="lead">أرسلنا رمزًا من 4 أرقام إلى <bdi dir="ltr" class="num">+966 5•• ••• •67</bdi></p>'
            f'<div class="change-num">{link("تغيير الرقم")}</div>'
            f'{top_banner or ""}{otp(digits, state, focus)}{helper}{rs}<div class="grow"></div>'
            f'{btn("تحقق", "primary", loading=btn_state == "loading", disabled=btn_state == "disabled")}</div>')
    return phone(body, "ar")


def otp_success():
    body = (f'<div class="form center">{topbar("", "ar")}<div class="grow"></div>'
            f'<div class="success-ic">{icon("tick-circle", 40)}</div>'
            f'<h1 class="title">تم التحقق بنجاح</h1><p class="lead">جارٍ إعادتك إلى الصفحة الرئيسية…</p>'
            f'<div class="grow"></div></div>')
    return phone(body, "ar")


MAP_SVG = '''<svg class="map-bg" viewBox="0 0 390 760" preserveAspectRatio="xMidYMid slice" aria-hidden="true">
<rect width="390" height="760" fill="#EEF0EB"/>
<g fill="#E2E5DE"><rect x="18" y="40" width="120" height="90" rx="6"/><rect x="160" y="40" width="90" height="90" rx="6"/><rect x="272" y="40" width="110" height="90" rx="6"/>
<rect x="18" y="160" width="80" height="120" rx="6"/><rect x="120" y="160" width="130" height="120" rx="6"/><rect x="18" y="310" width="120" height="110" rx="6"/>
<rect x="272" y="300" width="110" height="140" rx="6"/><rect x="18" y="450" width="80" height="130" rx="6"/><rect x="120" y="470" width="130" height="110" rx="6"/>
<rect x="272" y="470" width="110" height="110" rx="6"/><rect x="18" y="610" width="230" height="120" rx="6"/><rect x="272" y="610" width="110" height="120" rx="6"/></g>
<rect x="272" y="160" width="110" height="110" rx="8" fill="#D3E8C9"/><circle cx="327" cy="215" r="22" fill="#C3DDB6"/>
<rect x="160" y="310" width="90" height="130" rx="8" fill="#D3E8C9"/>
<g stroke="#FFFFFF" stroke-linecap="round"><path d="M0 145 H390" stroke-width="14"/><path d="M0 595 H390" stroke-width="14"/><path d="M260 0 V760" stroke-width="16"/>
<path d="M108 145 V760" stroke-width="10"/><path d="M0 295 H260" stroke-width="10"/><path d="M0 455 H390" stroke-width="10"/><path d="M150 0 V145" stroke-width="8"/></g>
<path d="M-10 700 C 90 640, 160 560, 260 455 S 360 330, 400 300" stroke="#FFE8A3" stroke-width="12" fill="none"/>
<path d="M-10 700 C 90 640, 160 560, 260 455 S 360 330, 400 300" stroke="#FFD15C" stroke-width="2" fill="none" stroke-dasharray="10 8"/>
</svg>'''


def location_picker():
    pin = ('<div class="pick-pin"><div class="pp-head">' + icon("location", 26, "#fff") +
           '</div><div class="pp-stem"></div><div class="pp-shadow"></div></div>')
    body = (f'<div class="picker">{MAP_SVG}'
            f'<div class="pick-top">{topbar("اختيار الموقع", "ar")}'
            f'<div class="pick-search">{icon("search", 20, "#6D6D6D")}<span>ابحث عن مدينة أو حي</span></div></div>'
            f'{pin}<button class="pick-me" aria-label="موقعي الحالي">{icon("location", 22, "#014AE0")}</button>'
            f'<div class="pick-sheet"><div class="ps-grip"></div><div class="ps-label">الموقع المحدد</div>'
            f'<div class="ps-row"><span class="lh-pin">{icon("location", 20)}</span><div><b>الرياض، حي النرجس</b>'
            f'<small>حرّك الخريطة لتحديد موقعك بدقة</small></div></div>'
            f'{btn("تأكيد الموقع")}</div></div>')
    return phone(body, "ar")


# ---------------------------------------------------------------- page layout
# Screens-only document: each page shows phones with a short state label.
# Explanatory subtitles and page notes are accepted but not rendered.
def frame(ph, title, sub="", tags=()):
    tg = "".join(f'<span class="tag {t.lower()}">{t}</span>' for t in tags if t == "TBD")
    return f'<figure class="frame"><div class="ph-wrap">{ph}</div><figcaption><div class="cap-t">{e(title)} {tg}</div></figcaption></figure>'


def page(section, title, frames, note="", n=None):
    cls = f"frames n{len(frames)}"
    return (f'<section class="page screens"><header class="ph"><h2>{e(title)}</h2>'
            f'<div class="brand-mark">دورك</div></header>'
            f'<div class="{cls}">{"".join(frames)}</div></section>')


# ---------------------------------------------------------------- pages
pages = []

# Cover
pages.append(f'''<section class="page cover"><div class="cover-in">
<div class="eyebrow">Patient app · UI mockups v1 · for review</div>
<h1>دورك</h1><p class="cover-sub">Splash · Authentication · Home / nearby medical centers. Every required state is included.</p>
<div class="cover-grid">
<div><b>Behavior spec</b><span>Medical_App_Initial_Flows_Claude.md</span></div>
<div><b>Visual spec</b><span>Figma Design System (Input Field, Icons)</span></div>
<div><b>Layout</b><span>Arabic RTL baseline, plus English LTR versions of key screens</span></div>
<div><b>Date</b><span>2026-10-11</span></div></div>
<div class="legend"><span class="tag ds">DS</span> taken directly from the Design System
<span class="tag proposed">PROPOSED</span> not in the Design System; built from DS tokens and needs designer approval
<span class="tag tbd">TBD</span> needs a product decision</div>
<p class="cover-note">All names, specialties, addresses, distances, phone numbers and images are <b>sample content</b>, not product data. The logo is a replaceable placeholder.</p>
</div></section>''')

# Foundations
sw = [("#014AE0", "Primary", "DS"), ("#1D1D1D", "Text primary", "DS"), ("#6D6D6D", "Text secondary", "DS"),
      ("#FAFAFA", "Field surface", "DS"), ("#E5E5E5", "Field border", "DS"), ("#B54708", "Error / warning", "DS"),
      ("#067647", "Success", "DS"), ("#FFFFFF", "White", "DS"), ("#EBF1FE", "Primary tint", "PROPOSED"),
      ("#EFEFEF", "Skeleton", "PROPOSED")]
swatches = "".join(f'<div class="sw"><span style="background:{c}"></span><b>{n}</b><code>{c}</code><i class="tag {t.lower()}">{t}</i></div>' for c, n, t in sw)
types = [("Display 24/32 Bold", "display", "أهلًا بك في دورك", "PROPOSED"),
         ("Title md 20/28 Bold", "title", "أدخل رقم جوالك", "PROPOSED"),
         ("Title sm 16/24 Semibold", "t16", "المراكز الطبية القريبة منك", "PROPOSED"),
         ("Text lg 14/20 Semibold", "t14b", "مركز النخبة الطبي", "PROPOSED"),
         ("Text lg 14/20 Regular", "t14", "سنرسل لك رمز تحقق في رسالة نصية.", "DS"),
         ("Text md 12/18 Semibold", "t12b", "رقم الجوال", "DS"),
         ("Text md 12/18 Regular", "t12", "أدخل رقم جوال سعودي صحيح.", "DS")]
typ = "".join(f'<div class="ty"><div class="ty-meta">{n} <i class="tag {t.lower()}">{t}</i></div><div class="{c}" dir="rtl">{s}</div></div>' for n, c, s, t in types)
pages.append(f'''<section class="page"><header class="ph"><div><div class="eyebrow">Foundations</div><h2>Color, type and shape</h2></div><div class="brand-mark">دورك · UI Mockups v1</div></header>
<div class="two-col"><div><h4 class="blk">Color</h4><div class="swatches">{swatches}</div>
<h4 class="blk">Shape and spacing</h4><ul class="specs"><li>Radius <b>12px</b> on fields (DS), also used for buttons, chips and cards (PROPOSED)</li>
<li>Field height <b>44px</b>, horizontal padding <b>16px</b>, label gap <b>6px</b> (DS)</li><li>Button height <b>48px</b>; touch targets ≥ 44px (PROPOSED)</li>
<li>Spacing scale 4 · 6 · 8 · 12 · 16 · 24 · 32 (PROPOSED, extends DS 6/16)</li><li>Disabled = 50% opacity (DS)</li></ul></div>
<div><h4 class="blk">Typography</h4><p class="small">Latin: <b>Plus Jakarta Sans</b> (DS). Arabic: <b>Tajawal</b> (PROPOSED, the app's current font; Plus Jakarta Sans has no Arabic glyphs).</p>{typ}</div></div></section>''')

# Components
ds_fields = "".join([
    f'<div class="cmp" dir="rtl">{field_text("الاسم الكامل", "سارة أحمد")}<i class="tag ds">DS · Default</i></div>',
    f'<div class="cmp" dir="rtl">{field_text("الاسم الكامل", "سارة أحمد", "focused")}<i class="tag ds">DS · Focused</i></div>',
    f'<div class="cmp" dir="rtl">{field_text("البريد الإلكتروني", "sarah@clinic", "error", "أدخل بريدًا إلكترونيًا صحيحًا.", "ltr")}<i class="tag ds">DS · Error</i></div>',
    f'<div class="cmp" dir="rtl">{field_mobile("55 555 5555", "valid", helper="رقم صحيح")}<i class="tag ds">DS · Mobile / Valid</i></div>',
])
prop = "".join([
    f'<div class="cmp" dir="rtl">{btn("إرسال رمز التحقق")}{btn("اختيار الموقع يدويًا", "secondary")}{btn("إرسال رمز التحقق", disabled=True)}<i class="tag proposed">PROPOSED · Buttons: primary, secondary, disabled</i></div>',
    f'<div class="cmp" dir="rtl"><div class="chips static"><span class="chip sel">الكل</span><span class="chip">الأسنان</span><span class="chip dis">العيون</span></div><i class="tag proposed">PROPOSED · Chip: selected, normal, disabled</i></div>',
    f'<div class="cmp" dir="rtl">{loc_header("ar")}<i class="tag proposed">PROPOSED · Location header</i></div>',
    f'<div class="cmp" dir="rtl">{otp("12", "default", 2)}<i class="tag proposed">PROPOSED · OTP input (4 cells, built from DS field tokens)</i></div>',
    f'<div class="cmp" dir="rtl">{card_skeleton()}<i class="tag proposed">PROPOSED · Skeleton</i></div>',
    f'<div class="cmp" dir="rtl">{banner("تعذّر إرسال الرمز. تحقق من اتصالك وحاول مرة أخرى.")}<i class="tag proposed">PROPOSED · Inline error banner (DS error color)</i></div>',
])
pages.append(f'''<section class="page"><header class="ph"><div><div class="eyebrow">Components</div><h2>From the Design System, and proposed additions</h2></div><div class="brand-mark">دورك · UI Mockups v1</div></header>
<div class="two-col"><div><h4 class="blk">Input field (DS, 5 types × 7 states; 4 shown)</h4><div class="cmp-grid">{ds_fields}</div>
<h4 class="blk">Icons (DS: Hicon Linear 24px)</h4><div class="icon-row">{"".join(f'<span title="{n}">{icon(n, 24)}<small>{n}</small></span>' for n in ["location","location-cross","map","chevron-down","chevron-left","call","group","search","category","refresh","wifi","danger-circle","info-circle","tick-circle","time-circle","profile"])}</div></div>
<div><h4 class="blk">Missing from the Design System, so proposed</h4><div class="cmp-grid">{prop}</div></div></div></section>''')

# Card sheet
ar0, en0 = CENTERS["ar"][0], CENTERS["en"][0]
fallback = dict(CENTERS["ar"][2], dist=None, docs=None)
longc = dict(CENTERS["ar"][1], name="مجمع الشفاء الطبي التخصصي لطب الأطفال والجلدية والتجميل", addr="حي الياسمين، شارع الثمامة، بجوار مجمع الياسمين التجاري، مبنى رقم 4")
cards_sheet = f'''<div class="card-sheet">
<div class="cs-item" dir="rtl" lang="ar">{card(ar0, "ar")}<p><b>Arabic UI, full data.</b> Shows <code>name_ar</code> and <code>description_ar</code> only.</p></div>
<div class="cs-item" dir="ltr" lang="en">{card(en0, "en")}<p><b>English UI, full data.</b> Shows <code>name_en</code> and <code>description_en</code> only. The two languages never appear together.</p></div>
<div class="cs-item" dir="rtl" lang="ar">{card(fallback, "ar")}<p><b>No image, distance or doctor count.</b> Uses a neutral image fallback; rows without valid data are hidden, not faked.</p></div>
<div class="cs-item" dir="rtl" lang="ar">{card(longc, "ar")}<p><b>Long text.</b> Name: up to 2 lines. Address: 1 line. Description: 2 lines, ending in "…". Full values go to accessibility labels.</p></div></div>
<table class="map"><tr><th>Data field</th><th>Shown on the card as</th></tr>
<tr><td><code>medical_center_image</code></td><td>72×72 thumbnail, 12px radius; neutral fallback if missing</td></tr>
<tr><td><code>name_ar</code> / <code>name_en</code></td><td>Title, 14/20 semibold, active language only</td></tr>
<tr><td>specialty (discovery data)</td><td>Primary-color line under the title. Mapping is TBD.</td></tr>
<tr><td><code>city</code> · <code>address</code></td><td>Location icon + one line, truncated</td></tr>
<tr><td>distance (computed)</td><td>Badge at the end of the title row; only shown when it can be calculated</td></tr>
<tr><td><code>description_*</code></td><td>2-line excerpt</td></tr>
<tr><td><code>doctor_count</code> · <code>phone</code></td><td>Footer row; the phone number is tap-to-call if implemented</td></tr>
<tr><td>coordinates</td><td>Used for proximity only; no map inside the card</td></tr></table>'''
pages.append(f'''<section class="page"><header class="ph"><div><div class="eyebrow">Component · PROPOSED</div><h2>Medical center card</h2></div><div class="brand-mark">دورك · UI Mockups v1</div></header>{cards_sheet}
<p class="page-note">Order: image → name → specialty → city/address → distance → description → doctors/phone. No ratings, prices, opening hours or booking button. Tapping the card leads to center details, which is <b>TBD</b> and out of scope.</p></section>''')

# Flow A + B1
pages.append(page("Flow A · Flow B1", "Splash and authentication entry", [
    frame(splash(), "A · Splash", "Opens Home as a guest; no login wall. A spinner shows only if startup is genuinely slow.", ("PROPOSED",)),
    frame(auth_entry("ar"), "B1 · Authentication entry (AR)", "Only opened when the user chooses to sign in. 'Continue as guest' returns to Home.", ()),
    frame(auth_entry("en"), "B1 · Authentication entry (EN)", "English LTR. The brand name stays «دورك»; no English spelling is approved yet.", ()),
], note="<b>TBD:</b> terms and privacy links stay hidden until approved URLs and copy exist. The Apple and Google buttons must follow official branding. The Design System's Google 'G' is monochrome, but Google requires the multicolor mark."))

pages.append(page("Flow B1", "Apple / Google hand-off and return states", [
    frame(auth_entry("ar", overlay="جارٍ تسجيل الدخول باستخدام Apple…"), "Signing in with Apple", "Native Apple sheet → returns here while the session is created"),
    frame(auth_entry("ar", notice=banner("تم إلغاء تسجيل الدخول. يمكنك المحاولة مجددًا أو المتابعة كزائر.", "info", "info-circle")), "Cancelled by the user", "Neutral notice; nothing is blocked"),
    frame(auth_entry("ar", notice=banner("تعذّر تسجيل الدخول باستخدام Google. حاول مرة أخرى.")), "Provider failure", "Error banner in the DS error color; the user can retry"),
], note="When sign-in succeeds, the user returns to where they were (if a future flow provided a destination) or to Home, keeping their location and specialty selection."))

pages.append(page("Flow B3 · proposed, TBD with backend", "Verification code (OTP)", [
    frame(otp_screen(focus=0), "Empty", "Resend countdown is running"),
    frame(otp_screen("1294", "error", msg="الرمز غير صحيح. تحقق منه وحاول مرة أخرى.", btn_state="enabled", resend="available"), "Invalid code", "DS error border and message"),
    frame(otp_success(), "Success", "→ Home, or the screen the user came from"),
], note="<b>Decision needed:</b> is phone sign-in passwordless OTP, and does a first successful verification create the account? No registration form is designed until this is answered."))

# Home
ar_c, en_c = CENTERS["ar"], CENTERS["en"]
dent = [ar_c[0], dict(ar_c[2], name="عيادات ابتسامة الرياض", sp="الأسنان", dist="5.2", img="center-smile.jpg", docs="6",
                      desc="علاج وتقويم الأسنان للكبار والأطفال.", addr="حي الصحافة، شارع العليا")]
pages.append(page("Flow C · Home", "Discover nearby medical centers: results", [
    frame(home("ar"), "Results (AR)", "Order: location → specialties → nearby centers"),
    frame(home("en"), "Results (EN)", "English LTR; English data fields only"),
    frame(home("ar", selected=1, centers=dent), "Specialty selected: الأسنان", "Refreshes results for the same location; tap الكل to clear"),
], note="Guests can use everything on this screen without signing in. No bottom navigation, search or map: none of these are in the spec. A result count appears only if the backend provides one."))

pages.append(page("Flow C · Home", "Location permission and availability", [
    frame(home("ar", "unset", state=state_block("location", "اعرض المراكز القريبة منك",
          "نستخدم موقعك لعرض المراكز الطبية القريبة فقط. يمكنك أيضًا اختيار موقعك يدويًا.",
          ("السماح بالوصول للموقع",), "اختيار الموقع يدويًا", "brand")), "Permission not requested yet", "Explains why before the system prompt appears"),
    frame(home("ar", "unset", state=state_block("location-cross", "لم يتم السماح بالوصول للموقع",
          "لعرض المراكز القريبة، اختر موقعك يدويًا أو فعّل إذن الموقع من الإعدادات.",
          ("اختيار الموقع يدويًا",), "فتح الإعدادات")), "Permission denied", "Manual location is offered first; no fake nearby list"),
    frame(home("ar", "resolving", results="skeleton"), "Finding location", "No address is shown until one is found"),
]))

pages.append(page("Flow C · Home", "Manual location and loading", [
    frame(home("ar", "manual"), "Manual location selected", "The label changes to 'Selected location'"),
    frame(home("ar", results="skeleton"), "Loading centers", "Card skeletons (PROPOSED)"),
    frame(home("ar", spec_mode="failed"), "Specialties failed to load", "Inline retry; 'All' still works. If no specialties exist, only 'All' is shown"),
]))

pages.append(page("Flow C · Home", "Empty state and location picker", [
    frame(home("ar", state=state_block("map", "لا توجد مراكز طبية قريبة من هذا الموقع",
          "جرّب تغيير الموقع لعرض مراكز في منطقة أخرى.", ("تغيير الموقع",))), "No centers near this location", ""),
    frame(location_picker(), "Pick location on map"),
]))

# Decisions
dec = [
    ("1", "Which action requires an account?", "Sign-in is designed as a standalone flow and isn't linked to any button yet."),
    ("2", "Is phone sign-in passwordless OTP? Are profile fields needed on first sign-in?", "B3 is drawn as passwordless OTP with 4 digits, following the current app."),
    ("3", "Is the whole first release bilingual?", "Key screens are shown in both AR and EN."),
    ("4", "How is a location chosen: city/district, typed address, map pin?", "The picker screen is a TBD placeholder."),
    ("5", "What counts as 'nearby' (radius, city, backend ranking)?", "Distance is shown only when the backend provides it."),
    ("6", "The specialty list, and whether a center can have several", "The card can show several specialties (e.g. الجلدية · الأطفال)."),
    ("7", "Search, map view or tabs on Home?", "None were added."),
    ("8", "What does tapping a card do?", "Center details are out of scope."),
    ("9", "Should all card fields always be visible?", "Taller card; the description is cut to 2 lines."),
    ("DS", "The Design System has no buttons, chips, cards, headings, skeletons or Arabic font", "These are PROPOSED here and need designer approval."),
    ("DS", "Google 'G' glyph", "The DS version is monochrome; Google's branding requires the multicolor mark."),
    ("Brand", "Final logo and English brand spelling", "A «دورك» placeholder is used."),
]
rows = "".join(f"<tr><td>{a}</td><td>{e(b)}</td><td>{e(c)}</td></tr>" for a, b, c in dec)
pages.append(f'''<section class="page"><header class="ph"><div><div class="eyebrow">Next steps</div><h2>Open decisions before implementation</h2></div><div class="brand-mark">دورك · UI Mockups v1</div></header>
<table class="map dec"><tr><th>#</th><th>Question</th><th>How these mockups handle it</th></tr>{rows}</table></section>''')

# ---------------------------------------------------------------- write
# Keep only the phone-screen pages (cover/foundations/components/card sheet/decisions
# live in design-tokens.md and accessibility-review.md instead).
pages = [p for p in pages if 'class="frames' in p]
css = (ROOT / "mockups.css").read_text(encoding="utf-8")
doc = f'''<!doctype html><html lang="en"><head><meta charset="utf-8"><title>دورك · UI Mockups v1</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=block" rel="stylesheet">
<style>{css}</style></head><body>{"".join(pages)}</body></html>'''
(ROOT / "mockups.html").write_text(doc, encoding="utf-8")
print(f"wrote mockups.html with {len(pages)} pages")
