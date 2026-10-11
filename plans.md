# Geliştirme planı ve ilerleme

Son güncelleme: 11 Ekim 2026

## Durum kuralları

- `[ ]`: başlanmadı; `[~]`: sürüyor; `[x]`: tamamlandı ve kanıtı mevcut.
- Her uygulama adımından sonra ilgili görev ve ilerleme günlüğü güncellenir.
- Faz, tüm teslim koşulları sağlanmadan tamamlandı sayılmaz.
- Tasarım belgesinin yazılması, oyunun veya oyuncu deneyiminin tamamlandığı anlamına gelmez.
- Oynanış değişirse PRD, bölüm verisi ve oyuncu yolculuğu birlikte gözden geçirilir.

## Hazırlık — tamamlandı

- [x] MDA, kapsam ve sekiz bölüm tasarımını `prd.md` içinde tanımla.
- [x] Faz ve görev takibini oluştur.
- [x] Oyuncu deneyimi hipotezlerini ve test sorularını oluştur.
- [x] Veri tabanlı bölüm mimarisini ve kayıt kurallarını tanımla.
- [x] Higgsfield için görsel yön ve varlık listesini hazırla.

Kanıt: Bu klasördeki beş tasarım belgesi. Godot 4.7.2 ile mevcut klasörde oynanabilir dört bölümlük prototip oluşturuldu.

## Faz 1 — Temel oyun ve dört Çatı Mahallesi bölümü

Bağımlılık: Hazırlık belgeleri. Önce geçici basit görsellerle uçuş doğrulanır.

### Sistemler

- [x] Godot projesini kur; motor alt sürümünü sabitle, giriş eylemlerini ve ölçekleme ayarını tanımla.
- [x] Kanat çırpma, yerçekimi, sabit ilerleme, çarpışma ve yük etkisini uygula.
- [x] Ganimet toplama, kapasite sınırı ve görsel yük geri bildirimini uygula.
- [x] Ara teslim, son teslim, kayıp, sonuç ekranı ve hızlı yeniden denemeyi uygula.
- [x] Bölüm kataloğu, veri yükleyici ve anlaşılır hata veren bölüm doğrulayıcıyı kur.
- [x] Ana menü, bölüm seçimi, duraklatma ve temel ses ayarlarını ekle.
- [x] Sürümlü kayıt, güvenli yazma ve bakiyenin yalnızca bir kez işlenmesini uygula.

### Bölümler

- [x] CATI_01: güvenli açılış, geniş bacalar, kapaklar ve son yuva.
- [x] CATI_02: kaşık, yük deneme alanı ve ilk ara teslim seçimi.
- [x] CATI_03: güvenli/değerli rota ayrımı ve özel eşya konumu.
- [x] CATI_04: iki ara yuvalı beceri birleşimi ve mahalle kapanışı. Liman bölümleri Faz 2’de eklenecek.
- [x] Her bölümün başlangıç, en ağır yük ve yeniden deneme akışını doğrula.

### Sunum ve teslim

- [x] Görsel yön belgesine göre karga, çatı seti, ganimet ve yuva varlıklarını hazırla.
- [x] Toplama, teslim ve çarpışma seslerini ekle; ses kaynaklarını kaydet.
- [ ] Dört bölümün ilk oyuncu testini yap; bulguları oyuncu yolculuğuna işle.
- [ ] Teslimin bölüm tamamlama ile farkının anlaşılır olduğunu doğrula.

Çıkış koşulu: Dört bölüm oynanabilir, yeniden başlatma ve kayıt güvenilir, temel karar anlaşılır. Oyuncu testi yapılmadıysa faz doğrulanmış sayılmaz.

## Faz 2 — Dört Rüzgârlı Liman bölümü ve kalıcı aidiyet

Durum: Oynanabilir uygulama ve teknik/görsel kontroller tamamlandı. Faz 1 ve Faz 2 insan oyuncu testleri açık tutuluyor.

Bağımlılık: Faz 1 oyun döngüsü ve bölüm yükleyici çalışıyor olmalı.

### Sistemler ve ilerleme

- [x] Görsel yön ve sınır göstergeli rüzgâr alanlarını ekle.
- [x] Bölüm zamanına bağlı, tekrar denemede aynı evreden başlayan sallanan yükleri ekle.
- [x] Özel eşya teslimi ve koleksiyon ekranını uygula; ilk dört bölüme bağla.
- [x] Dört kozmetik dekor ve yuva ekranını ekle; fizik avantajı vermediğini doğrula.
- [x] Bölüm başına üç bağımsız başarı işaretini göster.
- [x] Faz 1 kayıtlarından geçişi ve eksik yeni alanların varsayılan değerlerini test et.

### Bölümler

- [x] LIMAN_01: güvenli rüzgâr öğretimi.
- [x] LIMAN_02: sallanan yüklerin bağımsız öğretimi.
- [x] LIMAN_03: rüzgâr, ağırlık ve rota kararlarının birleşimi.
- [x] LIMAN_04: final rotası, isteğe bağlı madalya ve kapanış.
- [x] Sekiz bölümün açılma sırasını, hedeflerini ve koleksiyon teslimlerini doğrula.

### Sunum ve teslim

- [x] Liman arka planı, vinç, yük, rüzgâr efektleri ve müziği ekle.
- [x] Yuvanın başlangıç/ilerleme/kapanış görünümünü hazırla.
- [ ] Liman öğretimi ve aidiyet hissini oyuncularla test et.

Çıkış koşulu: Sekiz bölüm, iki ayrı bölge kimliği, kalıcı koleksiyon ve dekor çalışır; eski kayıt korunur.

## Faz 3 — Yayın kalitesi ve güncellenebilirlik

Durum: Teknik uygulama ve yerel macOS test paketi tamamlandı. İnsan oyuncu testine dayalı dengeleme açık.

Bağımlılık: Sekiz bölümün uygulanması. Bu faz yeni bölüm üretme sözü değildir.

- [~] Zorunlu rotaları tüm yük seviyelerinde kontrol et: tamamlandı. İnsan oyuncu bulgularına göre zorluk eğrisini düzenleme: bekliyor.
- [x] Tuş atama, sarsıntı azaltma, ses kontrolleri ve yardımcı oyun hızı seçeneğini tamamla.
- [x] Yardımcı hızın fiziği ve hareketli engelleri aynı oranda yavaşlattığını doğrula.
- [x] Hedef masaüstü çözünürlüklerinde arayüzü ve okunabilirliği kontrol et.
- [x] Hedef test makinesini kaydet; yoğun sahnede 60 FPS hedefini ölç.
- [x] Kayıt bozulması, yedekten kurtarma ve eski sürümden geçişi test et.
- [x] Oyuncuya sunulmayan dokuzuncu deneme bölümünü yalnızca veri/katalogla ekleyerek genişletilebilirliği kanıtla.
- [x] Eksik kaynak, yinelenen kimlik ve hatalı önkoşul için doğrulayıcı hata senaryolarını kontrol et.
- [x] Sekiz bölümün temiz kurulumdan finaline kadar son oynanış kontrolünü yap.
- [x] Varlık kaynakları/lisansları, sürüm notları ve dışa aktarım paketini hazırla.

Çıkış koşulu: Yayın paketi çalışır, kayıt uyumluluğu ve bölüm ekleme yolu kanıtlanır, bilinen sorunlar kaydedilir.

## Sonraki içerik güncellemeleri

1. Yeni bölümün öğretim amacı ve hedef duygusunu tanımla.
2. Kalıcı kimlik, katalog girdisi, bölüm verisi ve gerekli varlıkları ekle.
3. Doğrulayıcıyı ve eski kayıtla açılışı kontrol et.
4. Zorunlu rotayı boş/tam yükle oyna; gerekiyorsa oyuncu testi yap.
5. `player_journey.md` ve sürüm notlarını güncelle.

Mevcut engelleri kullanan bölüm için çekirdek kod değişmemeli. Yeni mekanik içeren güncelleme yeni bir bileşen ve onun testlerini gerektirebilir.

## İlerleme günlüğü

| Tarih | Yapılan iş | Kanıt / sonuç | Sonraki adım |
|---|---|---|---|
| 11 Ekim 2026 | Türkçe tasarım ve plan belgeleri oluşturuldu | Beş Markdown dosyası; uygulama başlamadı | Godot projesi ve geçici görsellerle temel uçuş prototipi |

| 11 Ekim 2026 | Godot 4.7.2 projesi, dört bölüm verisi ve oynanış uygulandı | `project.godot`, `scripts/`, `data/levels/`; yerel Godot ile çalıştırıldı | Otomatik ve görsel kontroller |
| 11 Ekim 2026 | Boş/tam yükle sekiz uçuş ve kayıt/etkileşim kontrolleri geçti | `tests/smoke.gd`: 24 kontrol, 0 başarısızlık | İnsan oyuncuyla anlaşılabilirlik ve zorluk testi |
| 11 Ekim 2026 | Menü ve oynanış görüntüleri Godot’tan alınıp incelendi | Türkçe arayüz; geçici kod çizimleri ve sentezlenmiş sesler | Nihai sanat ve oyuncu geri bildirimi |

## Güncel teslim durumu

Faz 1'in oynanabilir prototipi hazır. Dört bölüm sırayla açılır. Kanat çırpma, yük, ganimet, ara/son teslim, çarpışma, tekrar deneme, duraklatma, ses seçeneği ve kalıcı kayıt çalışır. Özel eşyalar Faz 2 kapsamında sekiz bölüme bağlandı; teslim ve koleksiyon çalışıyor. Higgsfield ile karga, çatı, ganimet ve yuva sanatı eklendi. İnsan oyuncu testi yapılmadığından Faz 1 bütünüyle doğrulanmış sayılmıyor.

Otomatik uçuş kontrolcüsü yalnızca test betiğindedir; oyun içinde otomatik pilot yoktur. Bu testler zorunlu rotaların fiziksel olarak geçilebilirliğini doğrular, insan için kolaylık veya eğlenceyi kanıtlamaz.

## Higgsfield sanat entegrasyonu — tamamlandı

- [x] Dört kareli karga ve çatı stili üretimi.
- [x] Aynı stilde ganimet, modüler baca ve yuva üretimi.
- [x] PNG şeffaflık, kare hizası ve piksel ölçeği kontrolü.
- [x] Godot görsel entegrasyonu ve ekran görüntüsü kontrolü.
- [x] Oynanış regresyon testleri ve varlık kaydı.

11 Ekim 2026: Higgsfield üzerinden dört üretim/düzeltme işi tamamlandı. Dört hizalı karga karesi, kapak, kaşık, modüler tuğla/baca başlığı, ara yuva, bayraklı son yuva ve kayan çatı arka planı oyuna bağlandı. Kaynaklar `assets/art/source/`, kullanım dosyaları `assets/art/`, kaynak kaydı `assets/manifest.json` içinde. Piksel filtreleme, alfa sınırları ve arka plan tekrar kenarı kontrol edildi. Godot içe aktarımı ve 24 oynanış kontrolü hatasız; menü, bölüm, ara yuva ve son yuva görüntüleri incelendi. Yük kesesi ve arayüz efektleri hâlen kodla çiziliyor.

11 Ekim 2026: Faz 2 başladı. Rüzgâr ve hareketli yükler ayrı çevre bileşenine, koleksiyon/dekor ilerlemesi sürümlü kayda ekleniyor.

11 Ekim 2026: Sekiz bölümün boş/tam yük uçuşları, v1→v2 kayıt geçişi, koleksiyon teslimi ve dekor işlemleri doğrulandı. Faz 2 ekranları Godot içinde görsel olarak inceleniyor.

## Faz 2 teslim kaydı — 11 Ekim 2026

- Dört Liman bölümü eklendi; toplam sekiz bölüm veri kataloğundan yükleniyor. CATI_04 tamamlanınca LIMAN_01 açılır.
- Rüzgâr alanları yön okları ve hareketli çizgilerle görünür. Sallanan yükler ortak bölüm zamanını kullanır; duraklatma ve tekrar deneme ile tutarlıdır.
- Sekiz özgün hatıra sprite'ı, kalıcı koleksiyon ve bölüm başına bitiş/ganimet/hatıra işaretleri eklendi.
- Yuvam ekranına dört görsel dekor eklendi. Satın alma öncesinde küçük önizleme ve fiyat görünür; alınan dekor kaldırılıp yeniden yerleştirilebilir. Fiyatlar 3/5/7/9; bunlar henüz oyuncu testiyle dengelenmiş değerler değildir.
- Higgsfield Liman arka planı, yük, dekor ve koleksiyon atlasları; iki özgün sentez bölge müziği oyuna bağlandı.
- Kayıt sürümü 2; sürüm 1 bakiyesi, bölüm başarıları ve ses tercihi korunur. Yeni alanlar boş koleksiyon/dekor listeleriyle başlar.
- `tests/smoke.gd`: **52 kontrol, 0 hata**. Sekiz bölümün boş/tam yükle toplam 16 otomatik uçuşu dâhil. Sonuç: `tests/phase2-results.txt`.
- `tests/phase2_preview.gd`: Liman menüsü, rüzgâr, vinç, dekorlu yuva ve final ekranı görüntüleri incelendi; `previews/phase2-*.png`.

Açık kalan: İnsan oyuncuyla rüzgârın anlaşılabilirliği, zorluk eğrisi, dekor fiyatları ve aidiyet hissi testi. Otomatik test sonuçları bu hislerin doğrulandığı anlamına gelmez. Bu kayıt Faz 2 teslim anını anlatır; Faz 3 durumu aşağıdadır.

## Faz 3 teslim kaydı — 11 Ekim 2026

- Uçuş/duraklatma/tekrar tuş ataması; çakışma engeli ve sabit Esc çıkışı.
- Ayrı müzik/efekt düzeyi, genel ses kapatma, %100/%75/%50 hız ve azaltılmış hareket. Oyunda ekran sarsıntısı kullanılmıyor; azaltılmış hareket arka plan kaymasını, rüzgâr çizgilerinin animasyonunu ve yeni parçacıkları durdurur. Statik yön okları korunur.
- Yardımcı hız aynı 60 Hz simülasyon adımlarını daha seyrek ilerletir. Fizik, engel zamanı ve animasyon aynı oyun zamanını kullanır. Pencere odağı kaybolunca duraklatma.
- Kayıt sürümü 3: sürüm 1/2 geçişi, ayar doğrulaması, bozuk kaydı koruma, daha yeni sürümü ezmeme, teslim/satın alma yazımı başarısızsa geri alma. Başarısız teslim için yeniden kayıt düğmesi.
- Sekiz bölüm × yedi yük seviyesi = **56 otomatik uçuş**. Genel testler 92, Faz 3 kabul testleri 40; **toplam 132 kontrol, 0 başarısızlık**.
- Temiz kayıtla sekiz bölüm sırayla tamamlandı. Dokuzuncu test bölümü yalnızca geçici JSON/katalog ile yüklenip oynandı ve kaydedildi; oyuncu kataloğuna eklenmedi. Menü ve koleksiyon sayfalaması doğrulandı.
- 640×360, 1280×720 ve 1440×900 pencere boyutlarında ayarlar ve yuva görüntüleri incelendi. Oynanış alanı 16:9 oranını korur.
- MacBook Pro / Apple M3 Max / 36 GB / macOS 27.0.1 / Godot 4.7.2 / OpenGL Compatibility: 1280×720 yoğun LIMAN_04 görünümünde 120 ısınma + 480 ölçüm karesi; ortalama **119,97 FPS**, medyan **9,15 ms**, P95 **14,85 ms**. Tam rapor `tests/phase3-performance.json`. Tek cihaz/sahne ölçümüdür.
- `builds/Parlak Isler.app` ve `builds/Parlak-Isler-0.3.0-macOS.zip` üretildi. Paket, kurulu export template olmadığı için Godot çalıştırıcısını dahil eder; yerel ad-hoc imzalıdır, Apple noter onayı yoktur. Intel ve Apple Silicon ikili mimarileri vardır; çalışma testi M3 Max üzerinde yapıldı.
- Bağımsız paket `/private/tmp` içinden hem gerçek pencerede hem sekiz bölüm/ayarlar/yuva doğrulamasıyla çalıştı. Test ve ham üretim dosyalarının PCK dışında olduğu doğrulandı.
- Kaynak/lisans kaydı `assets/manifest.json`, motor lisansları paket Resources klasöründe; sürüm notları `RELEASE_NOTES.md`.

Açık: İnsan oyuncu testleri, bu testlere dayalı zorluk/dekor ekonomisi ayarı; genel dağıtım için resmî release template ve Apple noter onayı. Yerel test paketi hazır; tam kamu yayını yapılmadı.

## README ve ekran görüntüleri — 11 Ekim 2026

- [x] Türkçe `README.md`: oyun fikri, mekanikler, sekiz bölüm, kontroller, çalıştırma, güncelleme yapısı ve Codex ile vibecoding süreci.
- [x] Güncel Godot sürümünden üç oynanış ve üç menü görüntüsü alındı: çatılar, rüzgâr, vinç, bölüm seçimi, Yuvam ve ayarlar.
- [x] Altı 1280×720 PNG `previews/readme/` içine kaydedilip README’ye eklendi; görüntüler görsel olarak incelendi ve belge bağlantıları kontrol edildi.
- [x] `tests/readme_screenshots.gd` ile tekrar üretilebilir çekim. Örnek ilerleme yalnızca bellekte tutulur; oyuncu kaydına yazılmaz.
