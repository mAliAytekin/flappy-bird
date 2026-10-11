# Görsel yön ve sanat üretim planı

Son güncelleme: 11 Ekim 2026
Durum: Faz 1 için Higgsfield görselleri üretildi, Godot’a eklendi ve oyun içi görünüm kontrol edildi.

## Üslup

Sıcak ve hafif mizahlı piksel görünümü. Karga küçük, yuvarlak gövdeli, koyu lacivert siluetli ve parlak eşyalara meraklıdır. Tehlikeler sertçe okunur; arka plan düşük kontrastlıdır. Kanat ve kuyruk uçları görsel hareket sağlar ama çarpışma sınırını büyütmez.

Mantıksal oyun alanı 960 × 540. Piksel varlıklar en yakın komşu örneklemeyle gösterilir; farklı piksel yoğunlukları karıştırılmaz. Görseller fizik tasarımına uydurulur; engel geçitleri görsele göre rastgele değiştirilmez.

## Bölge kimliği

| Bölge | Renk ve ışık | Arka plan | Ön plan |
|---|---|---|---|
| Çatı Mahallesi | Krem gökyüzü, kiremit turuncusu, sıcak gün batımı | Uzak evler, yumuşak bulutlar, düşük kontrastlı antenler | Keskin baca kenarları, belirgin yuva girişi, parlak metal ganimet |
| Rüzgârlı Liman | Mavi-yeşil hava, pas tonları, sarı vurgu | Uzak gemiler, sis ve vinç siluetleri | Okunaklı halatlar, sallanan yükler, yönü belli rüzgâr çizgileri |

Arka plan antenleri ile çarpışmalı antenler kontrast ve derinlik açısından ayrılır. Sis oynanış katmanını örtmez. Sarı vurgu yalnızca ganimette kullanılmazsa bile ganimet kendine özgü siluet ve parıltıya sahip olmalıdır.

## Varlık listesi

| Varlık | Hedef boyut / biçim | Faz | Kabul koşulu |
|---|---|---|---|
| Karga | 64 × 64 kare, şeffaf PNG; kanat döngüsü 4 kare | 1 | Her karede aynı gövde ölçeği ve merkez |
| Yük pozları | Aynı kare alanında hafif/orta/ağır taşıma | 1 | Gövde ve çarpışma hizası değişmez |
| Kapak, kaşık | 24 × 24 ve 32 × 32, şeffaf PNG | 1 | Küçük ölçekte birbirinden ayrılır |
| Baca ve anten | 32 birimlik ızgaraya oturan modüler parçalar | 1 | Tekrarlanan parçalarda dikiş oluşmaz |
| Ara ve son yuva | 128 × 96 görsel, giriş alanı ayrıca tanımlı | 1 | Güvenli giriş net; son yuva işareti farklı |
| Çatı arka planı | 960 × 540, ayrı gökyüzü/uzak/yakın katmanlar | 1 | Yatay tekrar uyumlu, düşük kontrast |
| Liman arka planı | Aynı katman ve ölçek düzeni | 2 | Çatı setiyle tutarlı piksel yoğunluğu |
| Vinç yükü ve halat | Modüler şeffaf PNG parçaları | 2 | Hareket pivotu ve çarpışma alanı tanımlı |
| Koleksiyon ve dekor | 32–96 birimlik varlıklar | 2 | Yuva ekranında tanınabilir |
| Arayüz simgeleri | 24 × 24 ve 32 × 32 | 1–2 | Metin veya renge tek başına bağımlı değil |

## Higgsfield kullanımı

Higgsfield, kullanıcı tarafından önerilen sanat üretim seçeneğidir. Önce bir karga ve bir çatı sahnesiyle stil denemesi yapılır; seçilen örnek sonraki üretimlere referans olur. Üretim kayıtları aşağıdaki entegrasyon bölümünde ve varlık manifestinde tutulur.

Örnek karga brifi: “Yandan görünen küçük, yuvarlak gövdeli, koyu lacivert bir karga. Sıcak ve mizahlı 2D piksel oyun karakteri. Sağa bakıyor. Net siluet, sabit kamera, sınırlı renk paleti, yazısız, arka plansız. Kanat hareketleri boyunca gövde boyutu ve merkez sabit.”

Örnek mahalle brifi: “Yandan akan 2D piksel oyunu için sıcak gün batımında çatı mahallesi. Krem gökyüzü, kiremit çatılar, uzak evler. Oynanış nesnelerinden düşük kontrast. Yazı, arayüz ve ana karakter yok. Katmanlara ayrılabilir, yatay tekrar için uygun kompozisyon.”

Üretim çıktısı doğrudan oyun varlığı kabul edilmez. Şeffaflık, boyut, kenar temizliği, animasyon tutarlılığı ve tekrar birleşimleri kontrol edilir. Gerekirse kareler elle düzeltilir. Alfa olmayan damalı arka plan şeffaflık sayılmaz. Görsellere arayüz metni gömülmez; metin Godot içinde çizilir.

## Varlık kaydı ve doğrulama

Üretim başladığında `assets/manifest.json` oluşturulur. Her varlık için dosya, kullanım amacı, kaynak/araç, üretim tarihi, kullanılan referans, kullanım hakkı notu, boyut ve kabul durumu kaydedilir. Ses kaynakları da aynı kayda dâhil edilir.

Oyun içi kabul: gerçek oynanış ölçeğinde siluet okunuyor, geçit sınırları görselle tutarlı, ağır yük pozu engeli gizlemiyor, ganimet ve yuvalar her iki arka planda seçiliyor. Sanat üretimi oynanabilir prototipin kurulmasını engellemez; ilk aşamada basit şekiller kullanılabilir.

## Faz 1 prototip varlıkları

İlk oynanabilir sürümde karga, yük kesesi, kapak, kaşık, bacalar, yuvalar ve katmanlı çatı arka planı `scripts/game.gd` içinde özgün geometrik çizimlerle üretilir. Bunlar nihai piksel sanat değildir. Toplama, dolu kapasite, teslim ve çarpışma sesleri aynı betikte sinüs dalgasından sentezlenir; dış ses dosyası kullanılmaz. Kaynak kaydı `assets/manifest.json` içindedir. Bu ilk prototip çizimlerinin karga, çatı, ganimet ve yuva kısımları aşağıdaki Higgsfield varlıklarıyla değiştirildi.

## Higgsfield entegrasyonu — 11 Ekim 2026

Üretim sağlayıcısı Higgsfield, model GPT Image 2.5. İlk karga çıktısı damalı ve alfasız olduğundan doğrudan kullanılmadı; aynı görsel referansıyla gerçek şeffaf PNG üretildi. Ganimet/yuva atlası da kargayı stil referansı olarak kullandı.

- Karga: dört adet 64 × 64 PNG; göz konumuna göre hizalı. Kanat çırpmadan sonra dört kare sırayla gösterilir, yeni çırpışta döngü yeniden başlar. Gövde çarpışma alanı korunur.
- Kapak 24 × 24, kaşık 32 × 32; gerçek alfa ve keskin piksel örneklemesi.
- Tuğla 32 × 32 döşenir; baca başlığı ayrı dokudur. Bölüm verileri ve çarpışma dikdörtgenleri değiştirilmedi.
- Ara ve son yuvalar 128 × 96; son yuva altın bayrakla ayrılır. Giriş göstergeleri ve metin Godot’ta çizilir.
- Çatı arka planı 960 × 540'tan aynalı 1920 × 540 panoramaya hazırlanır. İki kenar eşleşir ve düşük hızda kayar. Bu sürümde tek birleşik arka plan dokusu kullanılır; ayrı gökyüzü/uzak/yakın katman üretimi sonraki görsel iyileştirmeye bırakılmıştır.
- Yük kesesi ve ışık/giriş göstergeleri kod çizimi olarak korunur; ayrı yük pozları henüz üretilmedi.

Yeniden hazırlama: `python3 tools/prepare_art.py` (Pillow gerekir). Kaynak PNG’ler korunur. Araç atlasları böler, alfa eşiği uygular, kareleri hizalar ve nearest-neighbor ile hedef boyuta getirir. İş kimlikleri, boyutlar ve kaynaklar `assets/manifest.json` içindedir.

Görsel kontrol: Menü, bölüm, ara yuva ve son yuva Godot görüntüleri incelendi; alfa kenarları ve tekrar sınırı doğrulandı. İnsan oyuncuyla okunabilirlik testi henüz yapılmadı.

## Faz 2 sanat ve ses — 11 Ekim 2026

Higgsfield üzerinden önceki atlaslar stil referansı olarak kullanılarak mavi-yeşil Liman panoraması, paslı yük sandığı, kumaş, kapak süsü, lamba, rüzgâr çanı ve sekiz ayrı hatıra görseli üretildi. Ham PNG'ler `assets/art/source/` içinde, alfa eşikli ve oyun boyutuna indirilmiş sürümler `assets/art/` içinde. Kaynak iş kimlikleri ve boyutlar manifestte.

Rüzgâr yön okları ve akan çizgiler Godot'ta çizilir; kuvvet alanının gerçek sınırıyla aynı dikdörtgeni kullanır. Vinç kirişi/halatı kodla çizilir, yük Higgsfield dokusudur. Liman arka planı çatılardaki gibi aynalı tek panorama olarak kayar.

İki kısa bölge müziği özgün sinüs senteziyle üretildi; kaynak `tools/prepare_music.py`. Ses kapatma ikisini de kapsar, duraklatma müziği de durdurur. Görsel kontrol görüntüleri `previews/phase2-*.png` içinde. İnsan oyuncu değerlendirmesi bekliyor.
