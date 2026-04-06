import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import Stripe from "https://esm.sh/stripe@12.0.0?target=deno"

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') as string, {
  apiVersion: '2022-11-15',
  httpClient: Stripe.createFetchHttpClient(),
})

serve(async (req) => {
  // ตั้งค่า CORS ให้แอป Flutter ฝั่งหน้าบ้านเรียกใช้งานได้
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  }
  if (req.method === 'OPTIONS') return new Response('ok', { headers })

  try {
    // รับค่า ราคา และ ชื่อเพลง จากแอป
    const { amount, title } = await req.json()

    // สั่ง Stripe สร้าง QR Code PromptPay
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount * 100, // Stripe คิดเป็นสตางค์ เลยต้องคูณ 100
      currency: 'thb',
      payment_method_types: ['promptpay'],
      description: `Purchase: ${title}`,
    })

    // ดึง URL รููป QR Code ออกมา
    const qrUrl = paymentIntent.next_action?.promptpay_display?.hosted_instructions_url

    // ส่งกลับไปให้ Flutter โชว์บนหน้าจอ
    return new Response(JSON.stringify({ qrUrl, paymentIntentId: paymentIntent.id }), {
      headers: { ...headers, 'Content-Type': 'application/json' },
      status: 200,
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...headers, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})