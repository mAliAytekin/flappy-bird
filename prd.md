# Parlak İşler — Oyun tasarımı ve ürün gereksinimleri

Son güncelleme: 11 Ekim 2026
Durum: Sekiz bölümlük oyun, Faz 3 ayarları ve 0.3.0 yerel macOS test paketi hazır. Higgsfield sanatı eklendi. İnsan oyuncu testleri ve bunlara dayalı dengeleme bekliyor.

## Oyun fikri

Oyuncu küçük bir kargayı kontrol ederek çatılardaki parlak eşyaları toplar ve güvenli yuvalara teslim eder. Uçuş otomatik olarak sağa ilerler. Tek tuş kanat çırptırır. Ganimet değer kazandırırken ağırlığı uçuşu zorlaştırır. Temel karar: “Burada teslim edip güvenceye mi alayım, bir sonraki yuvaya kadar daha fazlasını mı taşıyayım?”

Hedef, kısa oturumlarda öğrenilebilen, tekrar deneyerek ustalaşılan, sıcak ve hafif mizahlı bir 2D oyun. İlk hedef platform masaüstü; klavye ve fare desteklenir. Dokunmatik kontrol mimaride mümkün tutulur; mobil yayın bu sürümün teslim koşulu değildir. Motor Godot 4, dil GDScript; kesin motor alt sürümü uygulama başlangıcında sabitlenecek.

## İlk sürümün kapsamı

- Faz 1: Çatı Mahallesi, dört bölüm ve temel oyun döngüsü.
- Faz 2: Rüzgârlı Liman, dört yeni bölüm, koleksiyon ve yuva ilerlemesi.
- Faz 3: Aynı sekiz bölümün dengelenmesi, erişilebilirlik, kayıt uyumluluğu ve yayın hazırlığı. Yeni bölüm zorunluluğu yok.
- Sonraki güncellemeler: Veri ve varlık paketleriyle yeni bölge ve bölüm ekleme.

Savaş, çevrim içi servisler, çok oyunculu mod, üretim sistemi, satın alınan uçuş gücü ve sonsuz mod ilk sürüme dâhil değildir.

## MDA çerçevesi

MDA; mekanikler, bu kuralların oynarken oluşturduğu dinamikler ve oyuncuda hedeflenen estetik/duygusal deneyim arasındaki ilişkiyi tanımlar. Buradaki estetik yalnızca görsel üslup değildir.

| Mekanik — kurallar | Dinamik — oyun sırasında oluşan davranış | Estetik — hedeflenen deneyim |
|---|---|---|
| Tek tuşla kanat çırpma ve otomatik ilerleme | Oyuncu aralıklara göre ritim kurar | Ustalık, akış, kontrol hissi |
| Değer ve ağırlığı farklı ganimetler | Oyuncu her eşyayı almak yerine rota ve yük seçer | Merak, gerilim, karar verme özgürlüğü |
| İsteğe bağlı erken teslim yuvaları | Oyuncu güvenli kazanç ile daha büyük kazancı karşılaştırır | Tatlı açgözlülük, rahatlama, sahiplenme |
| Çarpışmada yalnızca taşınan ganimetin kaybı | Kaybın sınırı anlaşılır, yeniden deneme kolaylaşır | Adalet, cesaret, yeniden deneme isteği |
| Önceden işaretlenen rüzgâr alanları | Oyuncu çevrenin hareketini okuyup uçuşunu ayarlar | Keşif, çevreye hâkim olma |
| Özel eşyalar ve yuva dekorasyonu | Toplanan nesneler kişisel bir hikâyeye dönüşür | Bağ kurma, ifade, aidiyet |
| Sabit tasarlanmış bölüm rotaları | Oyuncu önceki hatasından öğrenir | İlerleme ve yetkinlik hissi |

Tasarım önceliği: kontrol hissi → okunabilirlik → anlamlı risk → görsel zenginlik. Görsel efektler geçitleri, ganimeti ve rüzgâr yönünü gizleyemez.

## Oyun döngüsü ve sonuç kuralları

1. Bölüm seçilir; hedefler ve bulunmuş özel eşya gösterilir.
2. Kısa güvenli başlangıç alanında oyuncu uçuşa girer.
3. Oyuncu ganimet toplar, alternatif geçitleri ve yükünü yönetir.
4. Ara yuvanın belirgin giriş alanına girerse otomatik teslim olur ve uçuş biter. Girişten uzak geçen oyuncu yoluna devam eder; ikinci bir eylem tuşu gerekmez.
5. Ara teslim, ganimeti bankaya ekler ama bölümü tamamlamaz. Son yuvaya ulaşmak bölümü tamamlar ve sıradaki bölümü açar; asgari ganimet şartı aranmaz.
6. Çarpışma uçuşu bitirir; o uçuşta taşınanlar kaybolur, önceki teslimler korunur. Tek eylemle tekrar denenebilir.

Son yuva ana rotayı kapsayan geniş bir güvenli alandır; bitişte kaçırılabilir bir hassas manevra aranmaz. Ara yuvalar ana geçişi kapatmayan yan rotalardadır. Son yuvaya varmadan bölüm tamamlandı gösterilmez.

## Uçuş ve yük

- Eylemler: kanat çırpma, duraklatma, menüde onay/geri. Varsayılan uçuş: boşluk, sol fare düğmesi. Tuşa basma bir kanat çırpıştır; basılı tutma otomatik tekrar üretmez.
- Başlangıç ayar önerisi: 960 × 540 mantıksal alan, saniyede 180 birim yatay ilerleme, 850 birim/s² yerçekimi, boş yükte −300 birim/s kanat darbesi.
- Kapasite 6 ağırlık birimi. Kapak: ağırlık 1, değer 1; kaşık: ağırlık 2, değer 3. Bunlar denge testiyle değişebilir.
- Yük oranı 0–1 arasında sınırlandırılır. Tam yükte yerçekimi en fazla %15 artar, kanat darbesinin büyüklüğü en fazla %10 azalır. Yatay hız yüke göre değişmez.
- Kapasiteyi aşan eşya alınmaz; kısa görsel geri bildirim verilir, ceza uygulanmaz. Bu sürümde eşya bırakma yoktur.
- Çarpışma alanı görünür gövdeden biraz küçüktür; kuyruk ve kanat uçları ölüm nedeni değildir. Ekranın üst ve alt sınırları açıkça tehlike olarak gösterilir.
- Yük göstergesi, eşya değeri ve kuşun taşıma pozu birlikte bilgi verir. Renk tek başına bilgi taşımaz.

Sayısal değerler doğrulanmış denge sonucu değildir. En ağır yükle her zorunlu geçidin aşılabildiği test edilmelidir.

## Sekiz bölüm

Süreler ara teslim yapmadan son yuvaya ulaşmak içindir; başlangıç hedefidir. Bölümler rastgele üretilmez. Her bölümde bir özel koleksiyon eşyası bulunur; Faz 1'de yerleri hazırlanır, kalıcı koleksiyon Faz 2'de devreye girer.

| Kimlik / ad | Süre | Öğretim ve engeller | Risk / ödül ve yuvalar | Başarı koşulu |
|---|---|---|---|---|
| CATI_01 — İlk Kanat | 45–60 sn | Güvenli açılış, geniş baca aralıkları, kapaklar | Zorunlu olmayan birkaç kapak; yalnızca geniş son yuva | Son yuvaya ulaş |
| CATI_02 — Parlayan Yük | 60–75 sn | Kaşık ve yük göstergesi; geniş yük deneme alanından sonra yükseklik değişimleri | Yaklaşık %60'ta ilk ara yuva; ağır ve değerli rota ile hafif rota | Son yuvaya ulaş; isteğe bağlı değer hedefi |
| CATI_03 — İki Çatı Arası | 60–90 sn | Baca ve antenlerle üst/alt yol seçimi | Geniş yol az, dar yol çok ganimet; yaklaşık %65'te ara yuva | Son yuvaya ulaş; özel eşya isteğe bağlı dar rotada |
| CATI_04 — Son Bir Kaşık | 75–90 sn | Önceki becerilerin birleşimi; yeni tehlike eklenmez | Yaklaşık %45 ve %75'te ara yuvalar; ikinci yuvadan önce cazip ganimet | Son yuvaya ulaş ve limanı aç |
| LIMAN_01 — Esinti | 60–75 sn | Önce geniş güvenli alanda yukarı, sonra aşağı rüzgâr | Rüzgâr önceden parçacık ve yön işaretiyle görünür; %65'te ara yuva | Son yuvaya ulaş |
| LIMAN_02 — Halatların Arası | 75–90 sn | Sabit periyotlu sallanan yükler; ilk örnek rüzgârsız alanda | Güvenli alt geçit ve değerli zamanlama geçidi; %60'ta ara yuva | Son yuvaya ulaş |
| LIMAN_03 — Ağır Hava | 75–105 sn | Önce ayrı, sonra birlikte kullanılan yük ve rüzgâr | Bol ganimetli rüzgâr rotası veya sakin rota; %45 ve %75'te yuvalar | Son yuvaya ulaş |
| LIMAN_04 — Limanın Hazinesi | 90–120 sn | Rüzgâr, sallanan yük ve rota seçiminin finali; yeni mekanik yok | %50 ve %80'de yuvalar; isteğe bağlı özel madalya zor rotada | Son yuvaya ulaş; sekiz bölümlük sürümün kapanışı |

Her bölümün üç bağımsız işareti vardır: son yuvaya ulaşma, tanımlı değeri tek uçuşta teslim etme, özel eşyayı teslim etme. Değer hedefi ara veya son yuvada alınabilir. Özel eşya çarpışmayla kazanılmaz; teslim gerekir. Yalnızca tamamlanma işareti bölüm açılımını etkiler.

## İlerleme ve ekonomi

Bölümler belirtilen sırayla açılır. İlk bölüm baştan açıktır. Teslim edilen değer toplam harcanabilir bakiyeye eklenir; aynı sonuç olayı iki kez işlenemez. Dekor almak bakiyeyi azaltır, bölüm açılışını etkilemez. Özel koleksiyon eşyaları bir kez kaydedilir; tekrar uçuşlarda çoğaltılmaz ve zorunlu yük hesabını değiştirmemek için ağırlıksızdır. Normal ganimet tekrar toplanabilir.

Faz 2'de dört kozmetik yuva öğesi sunulur: kumaş, şişe kapağı süsü, küçük lamba, rüzgâr çanı. Satın alma öncesi görünüm ve fiyat gösterilir. Hiçbiri fizik veya ganimet değerini değiştirmez. Başlangıç fiyatları sırasıyla 3/5/7/9 değerdir; oyuncu teslim verileriyle dengelenecektir; ilerleme için tekrar oynama zorunlu kılınmaz.

## Görsel ve işitsel tasarım

Sıcak, hafif mizahlı piksel görünümü; koyu karga silueti ve açık okunaklı oynanış alanı. Çatı Mahallesi turuncu, krem ve kiremit tonlarında; liman mavi-yeşil, pas ve sarı vurgu renklerinde. Arka planın kontrastı tehlikelerden düşük tutulur. Üretim kuralları [art_direction.md](art_direction.md) içindedir.

Toplama, dolu kapasite, teslim, çarpışma ve rüzgâr ayrı geri bildirimlere sahiptir. Müzik yumuşak ve döngüseldir. Çarpışma oyuncuyu azarlayan uzun bir animasyona dönüşmez.

## Kabul koşulları

- Sekiz bölüm baştan sona tamamlanabilir; en ağır yük hiçbir zorunlu geçidi imkânsız yapmaz.
- Duraklatma fizik, bölüm zamanı ve hareketli engelleri birlikte durdurur.
- Çarpışma, teslim ve yeniden başlatma bakiyeyi yanlış artırmaz veya eski teslimleri silmez.
- Oyunu kapatıp açınca bölüm, koleksiyon, dekor ve ayarlar korunur.
- Dokuzuncu örnek bölüm veri dosyası ve kayıt girdisi eklenerek, oyun döngüsü kodu değişmeden yüklenir.
- Yeni içerik yüklenince eski kayıt ve bölüm başarıları korunur.
- Oyuncu testi, yükün etkisinin ve erken teslimin anlamının anlaşılabildiğini gösterir; test bulguları [player_journey.md](player_journey.md) içine yazılır.

## Bağlı belgeler

- [plans.md](plans.md): görevler, bağımlılıklar ve gerçek ilerleme.
- [player_journey.md](player_journey.md): hedeflenen hisler ve test yaklaşımı.
- [architecture.md](architecture.md): bölüm verisi, sistem sınırları ve kayıt uyumluluğu.
- [art_direction.md](art_direction.md): görsel üretim ve varlık kabul kuralları.

## 0.3.0 uygulama durumu

Uçuş, duraklatma ve tekrar tuşları değiştirilebilir. Esc sabit güvenli duraklatma/geri tuşudur. Ayrı müzik/efekt düzeyleri, %75/%50 yardımcı hız ve azaltılmış hareket uygulanmıştır. Yardımcı hız ödülleri değiştirmez. Kayıt sürümü 3, eski kayıtları varsayılan ayarlarla taşır. Yerel macOS paketinin açılışı proje klasörü dışında doğrulanmıştır. Teknik doğrulama: 132 otomatik kontrol; insan oyuncu testi henüz yapılmadı.
