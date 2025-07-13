# Assigning Roles
admin_role = Role.find_or_create_by!(name: "Admin")
user_role = Role.find_or_create_by!(name: "User")

# Create Admin User
admin_user = User.find_or_initialize_by(email: "harishgangani36@gmail.com")
admin_user.password = "123456"
admin_user.phone_number = "8003278155"
admin_user.gender = "Male"
admin_user.password = "123456"
admin_user.password_confirmation = "123456"
admin_user.name = "Harish Gangani"
admin_user.role = admin_role
admin_user.is_email_verified = 1
admin_user.is_phone_verified = 1
admin_user.save!

unless admin_user.image.attached?
  admin_user.image.attach(
    io: File.open(Rails.root.join('app', 'assets', 'images', 'admin.webp')),
    filename: 'admin.webp',
    content_type: 'image/webp'
  )
end

# Adding Category
categories_data = [
  { name: "Sweets", description: "Delicious traditional and modern sweet treats.", status: 1, image: "sweets.webp" },
  { name: "Dry Fruits", description: "Premium quality dry fruits and nuts.", status: 1, image: "dry_fruits.webp" },
  { name: "Speciality", description: "Exclusive and handcrafted specialty items.", status: 1, image: "speciality.webp" },
  { name: "Snacks", description: "Tasty and crunchy snacks for all moods.", status: 1, image: "snacks.webp" },
  { name: "Guilt Free", description: "Healthy and low-calorie treats for guilt-free indulgence.", status: 1, image: "guilt_free.webp" },
  { name: "Gifting", description: "Perfect gift packs and hampers for every occasion.", status: 1, image: "gifting.webp" },
]

categories_data.each do |cat|
  category_d = Category.find_or_initialize_by(name: cat[:name])
  category_d.description = cat[:description]
  category_d.status = cat[:status]
  category_d.save!

  unless category_d.image.attached?
    category_d.image.attach(
      io: File.open(Rails.root.join('app', 'assets', 'images', cat[:image])),
      filename: cat[:image],
      content_type: 'image/webp'
    )
  end
end

# Adding SubCategory For Our Speciality & Snacks & Gifting
sub_categories = [
  { name: "Mysore Pak", description: "A rich and buttery South Indian sweet made with ghee, gram flour, and sugar.", status: 1, image: "mysore_pak.webp", category_id: 3 },
  { name: "Motichoor Laddu", description: "Soft and melt-in-the-mouth laddus made from tiny gram flour pearls, soaked in syrup.", status: 1, image: "motichoor_laddu.webp", category_id: 3 },
  { name: "Ajmeri Kalakand", description: "A Rajasthani delicacy made from fresh paneer and milk, known for its rich, grainy texture.", status: 1, image: "ajmeri_kalakand.webp", category_id: 3 },
  { name: "South Indian Specials", description: "Authentic and flavorful dishes from the heart of South India.", status: 1, image: "south_indian_special.webp", category_id: 4 },
  { name: "Indian Backery", description: "Freshly baked Indian pastries, puffs, and breads with rich flavors.", status: 1, image: "indian_backery.webp", category_id: 4 },
  { name: "Tea Time Snacks", description: "Crispy, savory, and sweet bites perfect for your tea break.", status: 1, image: "tea_time_snacks.webp", category_id: 4 },
  { name: "Indian Cookies", description: "Traditional and fusion cookies with desi flavors and textures.", status: 1, image: "indian_cookies.webp", category_id: 4 },
  { name: "North Indian Specials", description: "Classic North Indian delights packed with bold spices and taste.", status: 1, image: "north_indian_special.webp", category_id: 4 },
  { name: "Assorted Dry Fruits Gift Box", description: "A premium mix of almonds, cashews, pistachios, and raisins - perfect for elegant gifting.", status: 1, image: "default_image.webp", category_id: 6},
  { name: "Gourmet Gift Box", description: "An elegant gift box filled with artisanal sweets and savory treats.", status: 1, image: "default_image.webp", category_id: 6},
  { name: "Festival Special Combo Gift Box", description: "A festive mix of traditional snacks and sweets curated for celebration.", status: 1, image: "default_image.webp", category_id: 6},
  { name: "Luxury Mithai Box", description: "Premium handcrafted Indian sweets with a modern twist, ideal for special occasions.", status: 1, image: "default_image.webp", category_id: 6},
  { name: "Savory & Sweet Hamper", description: "A balanced selection of crunchy savories and delightful sweets for gifting.", status: 1, image: "default_image.webp", category_id: 6 }
]

sub_categories.each do |cat|
  sub_category = SubCategory.find_or_initialize_by(name: cat[:name])
  sub_category.description = cat[:description]
  sub_category.status = cat[:status]
  sub_category.category_id = cat[:category_id]
  sub_category.save!

  unless sub_category.image.attached?
    sub_category.image.attach(
      io: File.open(Rails.root.join('app', 'assets', 'images', cat[:image])),
      filename: cat[:image],
      content_type: 'image/webp'
    )
  end
end

# Adding Product For Our Speciality
product = [
  {
    base_name: "Mysore Pak",
    description: "Traditional soft gram flour sweet from Karnataka.",
    shelf_life: 30,
    status: 1,
    sub_category_id: 1,
    weight: "250g", 
    image: "mysore_pak.webp",
    price: 220
  },
  {
    base_name: "Mysore Pak",
    description: "Traditional soft gram flour sweet from Karnataka.",
    shelf_life: 30,
    status: 1,
    sub_category_id: 1,
    weight: "500g", 
    image: "mysore_pak.webp",
    price: 400
  },
  {
    base_name: "Mysore Pak",
    description: "Traditional soft gram flour sweet from Karnataka.",
    shelf_life: 30,
    status: 1,
    sub_category_id: 1,
    weight: "1kg", 
    image: "mysore_pak.webp",
    price: 750
  },
  {
    base_name: "Murukku",
    description: "Crispy, spiral-shaped snack made with rice flour and spices.",
    shelf_life: 45,
    status: 1,
    sub_category_id: 1,
    weight: "200g", 
    image: "default_image.webp",
    price: 180
  },
  {
    base_name: "Murukku",
    description: "Crispy, spiral-shaped snack made with rice flour and spices.",
    shelf_life: 45,
    status: 1,
    sub_category_id: 1,
    image: "default_image.webp",
    weight: "400g", 
    price: 340
  },
  {
    base_name: "Murukku",
    description: "Crispy, spiral-shaped snack made with rice flour and spices.",
    shelf_life: 45,
    status: 1,
    sub_category_id: 1,
    weight: "800g", 
    image: "default_image.webp",
    price: 650
  },
  {
    base_name: "Veg Puff",
    description: "Spiced vegetable filling inside a flaky pastry crust.",
    shelf_life: 2,
    status: 1,
    image: "default_image.webp",
    sub_category_id: 2,    
    weight: "100g", 
    price: 60
  },
  {
    base_name: "Veg Puff",
    description: "Spiced vegetable filling inside a flaky pastry crust.",
    shelf_life: 2,
    status: 1,
    sub_category_id: 2,    
    weight: "200g", 
    image: "default_image.webp",
    price: 110 
  },
  {
    base_name: "Khari Biscuit",
    description: "Buttery, layered puff pastry biscuits, perfect with chai.",
    shelf_life: 15,
    status: 1,
    sub_category_id: 2,
    image: "default_image.webp",
    weight: "250g", 
    price: 150
  },
  {
    base_name: "Khari Biscuit",
    description: "Buttery, layered puff pastry biscuits, perfect with chai.",
    shelf_life: 15,
    status: 1,
    sub_category_id: 2,
    image: "default_image.webp",
    weight: "500g", 
    price: 280
  },
  {
    base_name: "Banana Chips",
    description: "Thinly sliced, crispy banana wafers fried in coconut oil.",
    shelf_life: 60,
    status: 1,
    sub_category_id: 3,
    image: "default_image.webp",
    weight: "200g", 
    price: 120
  },
  {
    base_name: "Banana Chips",
    description: "Thinly sliced, crispy banana wafers fried in coconut oil.",
    shelf_life: 60,
    status: 1,
    sub_category_id: 3,
    image: "default_image.webp",
    weight: "400g", 
    price: 230 
  },
  {
    base_name: "Banana Chips",
    description: "Thinly sliced, crispy banana wafers fried in coconut oil.",
    shelf_life: 60,
    status: 1,
    sub_category_id: 3,
    image: "default_image.webp",
    weight: "1kg", 
    price: 540
  },
  {
    base_name: "Mixture",
    description: "Spicy blend of sev, boondi, peanuts, and more.",
    shelf_life: 45,
    status: 1,
    sub_category_id: 3,
    image: "default_image.webp",
    weight: "250g", 
    price: 140
  },
  {
    base_name: "Mixture",
    description: "Spicy blend of sev, boondi, peanuts, and more.",
    shelf_life: 45,
    status: 1,
    sub_category_id: 3,
    image: "default_image.webp",
    weight: "500g", 
    price: 260
  },
  {
    base_name: "Mixture",
    description: "Spicy blend of sev, boondi, peanuts, and more.",
    shelf_life: 45,
    status: 1,
    sub_category_id: 3,
    image: "default_image.webp",
    weight: "1kg", 
    price: 480
  },
  {
    base_name: "Jeera Cookies",
    description: "Savory cumin-flavored biscuits with a crispy texture.",
    shelf_life: 30,
    status: 1,
    sub_category_id: 4,
    image: "default_image.webp",
    weight: "200g", 
    price: 100
  },
  {
    base_name: "Jeera Cookies",
    description: "Savory cumin-flavored biscuits with a crispy texture.",
    shelf_life: 30,
    status: 1,
    sub_category_id: 4,
    image: "default_image.webp",
    weight: "400g", 
    price: 190
  },
  {
    base_name: "Atta Biscuits",
    description: "Whole wheat cookies mildly sweetened and baked to perfection.",
    shelf_life: 30,
    status: 1,
    sub_category_id: 4,
    image: "default_image.webp",
    weight: "200g", 
    price: 90
  },
  {
    base_name: "Atta Biscuits",
    description: "Whole wheat cookies mildly sweetened and baked to perfection.",
    shelf_life: 30,
    status: 1,
    sub_category_id: 4,
    image: "default_image.webp",
    weight: "500g", 
    price: 210
  },
  {
    base_name: "Soan Papdi",
    description: "Flaky sweet made from gram flour, ghee, and sugar.",
    shelf_life: 60,
    status: 1,
    sub_category_id: 5,
    image: "default_image.webp",
    weight: "250g", 
    price: 160 
  },
  {
    base_name: "Soan Papdi",
    description: "Flaky sweet made from gram flour, ghee, and sugar.",
    shelf_life: 60,
    status: 1,
    sub_category_id: 5,
    image: "default_image.webp",
    weight: "500g", 
    price: 300
  },
  {
    base_name: "Soan Papdi",
    description: "Flaky sweet made from gram flour, ghee, and sugar.",
    shelf_life: 60,
    status: 1,
    sub_category_id: 5,
    image: "default_image.webp",
    weight: "1kg", 
    price: 580
  },
  {
    base_name: "Mathri",
    description: "Traditional flaky biscuit snack flavored with carom and cumin seeds.",
    shelf_life: 45,
    status: 1,
    sub_category_id: 5,
    image: "default_image.webp",
    weight: "300g", 
    price: 130
  },
  {
    base_name: "Mathri",
    description: "Traditional flaky biscuit snack flavored with carom and cumin seeds.",
    shelf_life: 45,
    status: 1,
    sub_category_id: 5,
    image: "default_image.webp",
    weight: "600g", 
    price: 250
  },
  {
    base_name: "Mathri",
    description: "Traditional flaky biscuit snack flavored with carom and cumin seeds.",
    shelf_life: 45,
    status: 1,
    sub_category_id: 5,
    image: "default_image.webp",
    weight: "1kg", 
    price: 420
  },
  {
    base_name: "Assorted Dry Fruits Gift Box",
    description: "A premium mix of almonds, cashews, pistachios, and raisins - perfect for elegant gifting.",
    shelf_life: 90,
    status: 1,
    sub_category_id: 9,
    weight: "500g",
    image: "default_image.webp",
    price: 850
  },
  {
    base_name: "Assorted Dry Fruits Gift Box",
    description: "A premium mix of almonds, cashews, pistachios, and raisins - perfect for elegant gifting.",
    shelf_life: 90,
    status: 1,
    sub_category_id: 9,
    weight: "1kg",
    image: "default_image.webp",
    price: 1200
  },
  {
    base_name: "Assorted Dry Fruits Mix Gift Box",
    description: "A premium mix of almonds, cashews, pistachios, and raisins - perfect for elegant gifting.",
    shelf_life: 90,
    status: 1,
    sub_category_id: 9,
    weight: "750g",
    image: "default_image.webp",
    price: 1050
  },
  {
    base_name: "Gourmet Gift Box",
    description: "An elegant gift box filled with artisanal sweets and savory treats.",
    shelf_life: 60,
    status: 1,
    sub_category_id: 10,
    weight: "1kg",
    image: "default_image.webp",
    price: 1200
  },
  {
    base_name: "Gourmet Gift Box",
    description: "An elegant gift box filled with artisanal sweets and savory treats.",
    shelf_life: 60,
    status: 1,
    sub_category_id: 10,
    weight: "2kg",
    image: "default_image.webp",
    price: 2000
  },
  {
    base_name: "Festival Special Combo Gift Box",
    description: "A festive mix of traditional snacks and sweets curated for celebration.",
    shelf_life: 45,
    status: 1,
    sub_category_id: 11,
    weight: "750g",
    image: "default_image.webp",
    price: 980
  },
  {
    base_name: "Luxury Mithai Box",
    description: "Premium handcrafted Indian sweets with a modern twist, ideal for special occasions.",
    shelf_life: 30,
    status: 1,
    sub_category_id: 12,
    weight: "1kg",
    image: "default_image.webp",
    price: 1350
  },
  {
    base_name: "Luxury Mithai Box",
    description: "Premium handcrafted Indian sweets with a modern twist, ideal for special occasions.",
    shelf_life: 30,
    status: 1,
    sub_category_id: 12,
    weight: "2kg",
    image: "default_image.webp",
    price: 2050
  },
  {
    base_name: "Savory & Sweet Hamper",
    description: "A balanced selection of crunchy savories and delightful sweets for gifting.",
    shelf_life: 45,
    status: 1,
    sub_category_id: 13,
    weight: "800g",
    image: "default_image.webp",
    price: 1050
  }
]
product.each do |cat|
  product = Product.new(
    name: cat[:base_name],
    description: cat[:description],
    status: cat[:status],
    price: cat[:price],
    shelf_life: cat[:shelf_life],
    weight: cat[:weight],
    sub_category_id: cat[:sub_category_id]
  )

  if cat[:image].present?
    image_path = Rails.root.join('app', 'assets', 'images', cat[:image])

    if File.exist?(image_path)
      product.image.attach(
        io: File.open(image_path),
        filename: cat[:image],
        content_type: 'image/webp'
      )
    else
      puts "⚠️ Image file not found: #{image_path}"
    end
  else
    puts "⚠️ No image provided for product: #{cat[:base_name]}"
  end

  product.save!
end

# Adding Speciality Module Data
fest_specials = [
  { name: "Diwali Delight", status: 1, image: "diwali_delight.webp", products: "28, 16, 21, 1" },
  { name: "Christmas Cheer", status: 0, image: "christmas_cheer.webp" }
]

fest_specials.each do |fest|
  fest_special = FestSpecial.find_or_initialize_by(name: fest[:name])

  # Parse and find product records
  product_ids = fest[:products].is_a?(String) ? fest[:products].split(',').map(&:strip).map(&:to_i) : fest[:products]
  products = Product.where(id: product_ids)

  fest_special.status = fest[:status]
  fest_special.products = products

  fest_special.save!

  unless fest_special.image.attached?
    fest_special.image.attach(
      io: File.open(Rails.root.join('app', 'assets', 'images', fest[:image])),
      filename: fest[:image],
      content_type: 'image/webp'
    )
  end
end

# Adding Blog
blogs = [
  {
    heading: "For the love of Mango",
    description: "<p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>If there's one fruit that captures the heart and soul of India, it's the mango. The arrival of mangoes marks the true beginning of summer sparking the passionate debates over which variety reigns supreme; Alphonso or Kesar, Dussehri or Langra? From bustling markets filled with golden heaps to roadside vendors blending refreshing mango shakes, the love for mango is deeply woven into our culture.</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>Even poets like Mirza Ghalib couldn't resist its charm, famously expressing his fondness: 'Aam meethe hon aur bahut saare hon', Mangoes should be sweet, and there should be plenty! From ancient poetry to modern-day mango festivals, this fruit continues to inspire joy and indulgence across India.</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>The silky texture, the intoxicating aroma, or the burst of sweetness with every bite is what makes it so irresistible. It's a fruit that defines childhood summers. Sticky hands, mango stained clothes, and the sheer joy of slurping aamras straight from the bowl.</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>Mangoes are an emotion, a tradition, and a festival in themselves. Whether devoured on their own, blended into creamy lassis, or transformed into rich desserts, they make everyone happy, making every meal feel like a celebration.</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'><img src='https://cdn.shopify.com/s/files/1/0569/3456/4001/files/Mango_3.png?v=1744867382'></span></p><p><br></p><p><strong style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>Aamotsav - The Ultimate Mango Indulgence</strong></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>This summer, indulge in the king of fruits like never before with Logo's Aamotsav, a celebration of mango in its most delicious forms. Be it the fresh and creamy aamras, a classic delight, best enjoyed chilled. Pair it with Fluffy puris and spiced aloo sabzi for a comforting summer meal or soft Malpua for a truly decadent experience.</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'><img src='https://cdn.shopify.com/s/files/1/0569/3456/4001/files/Mango_2.png?v=1744867382'></span></p><p><br></p><p><strong style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>When Classics Embrace Mango Magic!</strong></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>Indulge in your mango cravings with a delightful twist on your favourite Indian mithai. Experience the richness of Mango Kalakand filled with real mango chunks, creamy Mango Rabdi with a perfect balance of sweetness, delicate Mango Sandesh- A Bengali classic with a tropical twist,  the irresistible Mango Kacha Gola—a heavenly mango-infused Rasgulla and many more classics that's simply unmissable!</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>This season, let your mango cravings run wild, visit your nearest store and celebrate Aamotsav with Logo Sweet.</span></p><p><br></p>",
    image: "mango_blog.webp"
  },
  {
    heading: "Healthy Eating, the Indian Way: Superfoods for Modern Lifestyle",
    description: "<p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>As more people look for modern ways to eat healthier and lead active lifestyles, they often overlook the power of traditional Indian ingredients. Fresh, seasonal produce, authentic spices, and age-old cooking methods have gained a new appreciation in recent years for their incredible health benefits.</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>India is home to some of the most nutritious and delicious superfoods, perfect for daily consumption. Here are a few that deserve a place in your diet  and your heart:</span></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>Jaggery: A natural sweetener, jaggery is packed with iron and minerals, making it a great alternative to refined sugar. It aids digestion, detoxifies the liver, and provides sustained energy perfect for keeping you active throughout the day.</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>Dry Fruits: Almonds, cashews, pistachios, and walnuts are loaded with essential nutrients like healthy fats, protein, and antioxidants. They boost brain function, improve heart health, and keep you full for longer, making them a great snack option.</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>Pure Ghee: Once misunderstood, ghee is now recognised as a powerhouse of good fats. Made from pure cow's milk, it enhances digestion, strengthens immunity, and even helps in weight management when consumed in moderation.</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>Spices: Indian spices like turmeric, cinnamon, and cardamom are not just flavour enhancers; they are medicinal marvels. Turmeric, rich in cur cumin, has powerful anti-inflammatory properties, while cinnamon helps regulate blood sugar levels.</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>Makhanas (Fox Nuts): A fantastic low-calorie snack, makhanas are high in protein and antioxidants. They help control blood sugar, improve digestion, and support heart health while keeping cravings at bay.</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'><img src='https://cdn.shopify.com/s/files/1/0569/3456/4001/files/Healthy_3.png?v=1744264906'></span></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>Jowar &amp; Millets: Jowar, bajra, and ragi are ancient grains loaded with fibre, protein, and essential minerals. They aid digestion, support weight loss, and help manage diabetes. Jowar puffs, made from popped sorghum, are a light and crunchy way to enjoy this superfood.</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>Bringing all these superfoods together, we at Logo constantly strive to give traditional recipes a healthy twist without compromising on indulgence. Our range of Badamika, Pistamika, and Chocomika brings the joy of crispy Indian biscotti packed with premium dry fruits. Our Makhana, Jowar Puffs, and Trail Mix are coated with delicious spices for guilt free snacking. And for those who love traditional Indian sweets, we have evolved kaju katli, mysore pak and our health treats flax seed, gond, ragi, dink, millet laddus with jaggery, pure cow ghee, and premium dry fruits, ensuring you never miss out on taste or health.</span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'><img src='https://cdn.shopify.com/s/files/1/0569/3456/4001/files/Healthy_2.png?v=1744264991'></span></p><p><br></p><p><span style='background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);'>To order online, visit our website to pick and select from our wide range and get your loved ones door delivered a kit of health and wellness!</span></p><p><br></p>",
    image: "healthy_eating.webp"
  },
  {
    heading: "Iftaar Tables Around the World",
    description: "<p>On the joyous occasion of Eid, tables overflow with dishes that could feed an entire neighbourhood. The celebration begins at the sighting of the crescent moon, marking the end of Ramadan—a time for gratitude, togetherness, and, of course, a grand feast. Iftaar is more than just breaking the fast; it's a ritual that connects families, communities, and cultures across the globe. Let us explore the Iftaar table across the world.</p>
    <p><strong>Malaysia</strong></p>
    <p>In Malaysia, Iftaar is known as Berbuka Puasa, which translates to breaking the fast. The ritual begins with dates and water, a tradition shared by Muslims worldwide. One of the most popular Iftaar dishes is Bubur Lambuk, a spiced rice porridge cooked with beef, dates, and fragrant spices, often distributed by mosques. Another favourite is Murtabak, a stuffed, pan-fried bread with aromatic spices, making it a must-have during Ramadan.</p>
    <p><strong>Afghanistan</strong></p>
    <p>In Afghanistan, communal eating is at the heart of Iftaar. The legendary dish Painda, which translates to eating together, is a rich, flavourful gravy enjoyed with flatbread. Believed to have been a favourite of Prophet Muhammad, this dish is deeply rooted in tradition. As Eid approaches, the sweet aroma of Gosh-e-Fil, deep-fried pastries shaped like elephant ears and dusted with powdered sugar and pistachios, fills Afghan homes, signalling the festivities ahead.</p>
    <p><img src='https://cdn.shopify.com/s/files/1/0569/3456/4001/files/Untitled_design.png?v=1742890676' alt='Iftaar Table Image 1'></p>
    <p><strong>Turkey</strong></p>
    <p>Turkey's Ramadan spread features Pide, a soft, boat-shaped bread made exclusively during this time. Topped with vegetables and cheese is a staple on every Turkish Iftaar table. A warm bowl of Mercimek Çorbasi, a hearty red lentil soup, is also commonly served, bringing comfort after a long day of fasting. The blend of flavours and rich cultural history makes Turkish Iftaar truly special.</p>
    <p><strong>Indonesia</strong></p>
    <p>Indonesia's Iftaar table is a vibrant display of sweet and savoury delights. Gorengan, an assortment of crispy fried snacks like banana fritters and fried tofu, is a crowd favourite. Kolak, a warm dessert made with coconut milk, palm sugar, and sweet potatoes, provides a comforting end to the meal.</p>
    <p><strong>Pakistan</strong></p>
    <p>Pakistani Iftaar is a feast of indulgence. The table is filled with golden Samosas, crispy Pakoras, and spicy Aloo Chaps, all paired with the cooling delight of Dahi Vada, soft lentil dumplings soaked in yogurt and topped with tamarind chutney. Sweet treats like Jalebi and Fruit Chaat add a burst of flavour, while Rooh Afza, a fragrant rose flavoured drink, is a must-have to beat the summer heat.</p>
    <p><strong>India</strong></p>
    <p>India, with its rich culinary diversity, offers an Iftaar spread that varies by region. Yet, some classics remain constant. Dates and fresh fruits help replenish energy, while Chaat, a beloved street food, adds a tangy, crunchy twist to the feast. Dahi Vada, deep-fried lentil fritters soaked in spiced yogurt, is a staple on many tables, topped with chutneys and fresh herbs. The magic of Indian Iftaar lies in its bold flavours and vibrant traditions.</p>
    <p><img src='https://cdn.shopify.com/s/files/1/0569/3456/4001/files/Untitled_design_2.png?v=1742890676' alt='Iftaar Table Image 2'></p>
    <p>This year, make Logo a part of your Iftaar table with our exquisite range of festive delights. Break the fast with our premium Dates - Mejdool and Ajwa - along with a sip of our refreshing Sherbets and Shakes. Indulge in Rasmalai and creamy Rabdi and savour the golden perfection of Samosas and Kachoris — each bite infused with tradition and love. With Pan India delivery, you can now order our <a href='https://www.logosweets.in/products/kaju-katli' rel='noopener noreferrer' target='_blank'><strong>Kaju katli</strong></a>, khajoor burfi, and pure ghee Mysore online on our website and bring home the finest festive treats with ease. Celebrate the essence of Ramadan with Logo's handcrafted delicacies — because nothing brings people together like good food and great memories. Order online today and make your Iftaar table a true feast of joy and togetherness!</p>",
    image: "iftar.webp"
  }
]
blogs.each do |blog_data|
  blog = Blog.find_or_initialize_by(heading: blog_data[:heading])
  blog.description = blog_data[:description]
  blog.save!

  unless blog.image.attached?
    blog.image.attach(
      io: File.open(Rails.root.join("app", "assets", "images", blog_data[:image])),
      filename: blog_data[:image],
      content_type: 'image/webp'
    )
  end
end