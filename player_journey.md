# Oyuncu yolculuğu ve deneyim analizi

Son güncelleme: 11 Ekim 2026
Durum: Dört Çatı Mahallesi ve dört Liman bölümü uygulandı ve otomatik uçuşla doğrulandı. İnsan oyuncuyla deneyim testi henüz yapılmadı.

## Analizin kullanımı

Bu belge her bölümün ve tamamlanan fazın oyuncuda hangi hisleri uyandırmasının beklendiğini, bunların nasıl gözleneceğini kaydeder. Geliştirici niyeti oyuncunun gerçekten hissettiğinin kanıtı değildir. Uygulama tamamlandığında teknik durum; oyuncu testi yapıldığında gözlem ve sonuç ayrı güncellenir.

## Bölümden bölüme yolculuk

| Bölüm | Başlangıç hissi → hedeflenen bitiş hissi | Bunu sağlayan tasarım | Deneyim riski ve karşılık | Durum |
|---|---|---|---|---|
| CATI_01 — İlk Kanat | Tedirgin merak → “Uçabiliyorum” | Güvenli açılış, geniş aralıklar, hızlı yeniden deneme | Erken çarpışma yetersizlik hissettirirse ilk geçitleri genişlet | Uygulandı; oyuncu testi bekliyor |
| CATI_02 — Parlayan Yük | Toplama hevesi → “Yükümün sonucunu anlıyorum” | Kaşık sonrası güvenli deneme alanı, belirgin yük göstergesi | Ağırlaşma kontrol arızası sanılırsa görsel geri bildirimi artır ve fizik etkisini azalt | Uygulandı; oyuncu testi bekliyor |
| CATI_03 — İki Çatı Arası | Tereddüt → “Kendi yolumu seçtim” | Önceden görünen geniş/dar rota ve farklı ödül | Ayrım çok geç görünürse seçim yerine tuzak hissi doğar; görünür yaklaşımı uzat | Uygulandı; oyuncu testi bekliyor |
| CATI_04 — Son Bir Kaşık | Açgözlülük ve gerilim → rahatlama, temel ustalık | İki ara teslim fırsatı, ikinci yuvadan önce cazip ganimet | Erken teslim tamamlanma sanılırsa sonuç ekranında iki kavramı açık ayır | Uygulandı; oyuncu testi bekliyor |
| LIMAN_01 — Esinti | Yenilik merakı → “Rüzgârı kullanabilirim” | Geniş alanda tek başına rüzgâr, yön işaretleri | Görünmez kuvvet hissi oluşursa alan sınırlarını belirginleştir | Uygulandı; oyuncu testi bekliyor |
| LIMAN_02 — Halatların Arası | Dikkat → zamanlama başarısı | Okunaklı, düzenli sallanan yükler ve güvenli alternatif | Ezber zorunluluğu oluşursa hareketin daha erken görünmesini sağla | Uygulandı; oyuncu testi bekliyor |
| LIMAN_03 — Ağır Hava | Kontrollü endişe → bilinçli özgüven | Tanıdık kuralların birleşimi, sakin alternatif rota | Aşırı zihinsel yük varsa birleşim öncesi güvenli aralık ekle | Uygulandı; oyuncu testi bekliyor |
| LIMAN_04 — Limanın Hazinesi | Beklenti → gurur ve aidiyet | Öğrenilenlerin finali, isteğe bağlı madalya, gelişmiş yuvaya dönüş | Özel eşya zorunlu sanılırsa ana başarıyı koleksiyondan ayrı kutla | Uygulandı; oyuncu testi bekliyor |

## Faz tamamlandığında beklenen etki

### Faz 1: Güven ve anlamlı risk

Oyuncu tek tuşla yeterince kontrol sahibi olduğunu ve kaybın nedenini anlayabildiğini hissetmeli. Dört bölümün sonunda ganimeti otomatik toplamak yerine yüküne ve bir sonraki yuvaya bakarak karar vermesi beklenir. “Bir daha deneyebilirim” düşüncesi, “oyun beni cezalandırdı” hissinden baskın olmalı.

Gözlenecek davranışlar: Çarpışmanın nedenini açıklama, bilerek bir ganimeti pas geçme, ara teslimi kendi kararıyla seçme. Tüm oyuncuların aynı risk tercihinde bulunması beklenmez.

Gerçek sonuç: Henüz ölçülmedi. Faz tamamlanmadı.

### Faz 2: Keşif, yetkinlik ve aidiyet

Liman, önceden öğrenilen uçuş becerisini geçersiz kılmadan yeni bir çevre sunmalı. Oyuncu rüzgârı yalnızca tehlike değil kullanabileceği bir kuvvet olarak okumalı. Koleksiyon ve yuva, kazancı soyut puanın ötesinde görünür bir hatıraya dönüştürmeli. Sekizinci bölüm sonunda daha fazla içerik eklenebilecek olsa da mevcut sürüm tamamlanmış hissettirmeli.

Gözlenecek davranışlar: Rüzgâra göre önceden konumlanma, farklı rota deneme, dekor tercihine gerekçe sunma, özel eşyayı kendi isteğiyle arama.

Gerçek sonuç: Henüz ölçülmedi. Faz tamamlanmadı.

### Faz 3: Adalet, rahatlık ve güven

Bu fazın etkisi yeni bir oyun kuralı öğrenmekten çok sürtünmenin azalmasıdır. Oyuncu kayıtlarına güvenmeli, ayarlarıyla rahat oynayabilmeli ve tekrarlanan başarısızlıkları tutarlı kurallarla açıklayabilmeli. Güncelleme sonrası eski başarısının korunması aidiyeti sürdürmeli.

Gerçek sonuç: Henüz ölçülmedi. Faz tamamlanmadı.

## Oyuncu testi yöntemi

Her içerik fazı sonunda mümkünse oyunu daha önce oynamamış 3–5 kişiyle kısa gözlem oturumu yapılır. Bu küçük örneklem istatistiksel doğrulama sayılmaz; sorun bulmak için kullanılır. Geliştirici önce yönlendirmeden izler, sonra sorar:

- Neden çarptığını düşünüyorsun?
- Daha fazla eşya topladığında ne değişti?
- Ara yuvada durma veya devam etme kararını neye göre verdin?
- Sonraki bölümün nasıl açıldığını anladın mı?
- Hangi an adaletsiz, hangi an başarılı hissettirdi?
- Limanda rüzgârın yönünü ne zaman fark ettin?
- Yuvaya dönmek ve dekor eklemek senin için bir anlam taşıdı mı?

Yerel test notları: bölüm, deneme sayısı, çarpışma yeri, taşınan yük, teslim tercihi, oyuncunun kendi ifadesi. İlk sürümde çevrim içi analitik kurulması gerekmez. Sorunlar tekrar ederse tasarım değişikliği yapılır ve ilgili bölüm yeniden denenir.

## Gerçekleşen testler ve değişiklikler

Henüz insan oyuncu testi yapılmadı. Teknik doğrulamalar aşağıdaki uygulama kayıtlarında.

| Tarih / sürüm | Faz / bölüm | Gözlenen davranış ve oyuncu ifadesi | Yorum | Tasarım değişikliği | Yeniden test |
|---|---|---|---|---|---|
| — | — | Veri yok | Hipotezler doğrulanmadı | — | — |

## Faz 1 uygulama kaydı — 11 Ekim 2026

Dört bölümde boş/tam yükle son yuvaya ulaşan otomatik uçuşlar başarılı. Ara teslimin bölüm tamamlamaması, eski kazancın çarpışmada korunması ve yeniden deneme sıfırlaması da doğrulandı. Menü ve oynanış görüntüleri incelendi. Bunlar teknik bulgulardır; güven, gerilim ve aidiyet hipotezleri insan oyuncuyla henüz sınanmadı.

## Faz 2 uygulama kaydı — 11 Ekim 2026

Sekiz bölümün tamamı boş/tam yükle otomatik uçuş testini geçti. Rüzgârın bölgesel fizik etkisi, salınımın periyodu, duraklatmada zamanın donması, çarpışma, hatıranın yalnızca teslimde kazanılması ve dekorların fizik etkisinin olmaması doğrulandı. Eski kayıt geçişi ve koleksiyon/dekor geri yüklemesi dâhil 52 kontrol hatasız.

Oyuncu deneyimine karşılıkları henüz hipotezdir:

- Esinti: Geniş öğretim alanı ve oklarla görünür kuvvet, merakı kontrol hissine çevirmeyi hedefler.
- Halatların Arası: Rüzgârsız salınım öğretimi ve güvenli alt geçit, zamanlamayı baskı altında olmadan öğrenmeyi hedefler.
- Ağır Hava: Üst akıntı ve sakin alt rota, daha fazla ganimet ile daha güvenli uçuş arasında seçim sunar.
- Limanın Hazinesi: Önceden öğrenilen kuralların finali; yuvaya dönme düğmesi ve görünür tamamlanma ödülüyle kapanış amaçlanır.
- Yuvam: Satın alınan dekorlar ile teslim edilen hatıralar, kazancı kişisel bir yere dönüştürmeyi amaçlar. Kozmetikler bölüm açılımını ve uçuşu etkilemez.

İnsan oyuncu testi bekliyor. Özellikle yukarı rüzgârın ilk karşılaşmada anlaşılması, ağır yükle kontrol hissi ve dekor fiyatlarının tekrar oynama baskısı yaratıp yaratmadığı izlenecek.

## Faz 3 uygulama kaydı — 11 Ekim 2026

Tuş atama, ses düzeyleri ve %75/%50 yardımcı hız, oyuncunun rahatlığını ayarlayabilmesini hedefler. Yardımcı mod kazancı azaltmaz. Azaltılmış hareket görsel hareketi azaltırken rüzgâr yön bilgisini korur. Pencere odağı kaybolunca otomatik duraklatma, kontrol dışı kaybı önlemeyi amaçlar.

Kayıt arızasında sahte başarı gösterilmemesi ve eski dosyanın korunması, kazanımlara duyulan güveni destekler. Bu teknik davranışlar test edildi. 56 yük/bölüm uçuşu ile toplam 132 otomatik kontrol geçti; üç pencere boyutunda arayüz incelendi. Bunlar deneyimin adil/eğlenceli bulunduğunu kanıtlamaz.

Henüz insan oyuncu testi yok. Bu nedenle hissedilen zorluk, tuş atama ekranının anlaşılabilirliği, yardımcı hızda rahatlık ve koleksiyon motivasyonu hakkında sonuç bildirilmedi. Faz 3'ün kullanıcı doğrulaması açık tutuldu.
