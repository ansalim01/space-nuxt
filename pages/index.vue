<template>
  <div class="wrapper">
    <div class="content">
      <header class="header">
        <div class="header__title">
          ARMAGEDDON 2023
        </div>
        <div class="header__text">ООО “Команда им. Б. Уиллиса”. Взрываем астероиды с 1998 года.</div>
      </header>
      <main class="main">
        <div class="main__title">Ближайшие подлёты астероидов</div>
        <div class="main__toggle">
          <span :class="{
            'main__toggle-not-active': distanceMeasurements !== 'km',
            'main__toggle-active': distanceMeasurements === 'km',
          }"  @click="chooseKilometers">в километрах</span> |
          <span :class="{
            'main__toggle-not-active': distanceMeasurements !== 'lun',
            'main__toggle-active': distanceMeasurements === 'lun',
          }" @click="chooseLunar">в лунных орбитах</span>
        </div>
        <div class="main__row">
          <div class="row__items">
            <template v-for="nearEarthObject in nearEarthObjects" :key="nearEarthObject[0]">
              <template v-for="item in nearEarthObject[1]" :key="item.neo_reference_id">
                <div class="item">
                  <div class="item__title">{{ nearEarthObject[0] }}</div>
                  <div class="item__info">
                    <div class="item__distance">
                      <div class="item__distance-text">{{getDistanceMeasurements(item)}}</div>
                      <div class="item__distance-arr">
                        <svg xmlns="http://www.w3.org/2000/svg" width="129" height="6" viewBox="0 0 129 6" fill="none">
                          <path d="M0 3L5 5.88675L5 0.113249L0 3ZM129 3.00001L124 0.113259L124 5.88676L129 3.00001ZM4.5 3.5L124.5 3.50001L124.5 2.50001L4.5 2.5L4.5 3.5Z" fill="white" fill-opacity="0.5"/>
                        </svg>
                      </div>
                    </div>
                    <div class="item__img">
                      <img v-if="getDiameter(item) < 100" src="../assets/pngegg 1.png">
                      <img v-if="getDiameter(item) > 100" src="../assets/pngegg 2.png">
                    </div>
                    <div class="item__right">
                      <div class="item__right-title">{{getNearEarthObjectName(item.name)}}</div>
                      <div class="item__right-size">Ø {{ getDiameter(item) }} м</div>
                    </div>
                  </div>
                  <div class="item__bottom">
                    <div class="item__bottom-button">заказать</div>
                    <div class="item__bottom-warning" v-if="item.close_approach_data[0].miss_distance.lunar < 3">
                      <svg width="13px" height="13px" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" aria-hidden="true" role="img" class="iconify iconify--fxemoji" preserveAspectRatio="xMidYMid meet">
                        <path fill="#FFB636" d="M12.51 470.379L234.371 16.008c6.439-13.187 25.17-13.363 31.855-.299l232.51 454.371c6.064 11.849-2.542 25.92-15.853 25.92H28.512c-13.164 0-21.778-13.791-16.002-25.621z"></path>
                        <path fill="#2B3B47" d="M284.332 173L272.15 336.498c-.911 12.233-11.567 21.411-23.8 20.499c-11.116-.828-19.706-9.707-20.499-20.499L215.668 173c-1.413-18.961 12.813-35.478 31.774-36.89s35.478 12.813 36.89 31.774c.124 1.662.109 3.5 0 5.116zM250 391.873c-17.432 0-31.564 14.131-31.564 31.564C218.436 440.869 232.568 455 250 455s31.564-14.131 31.564-31.564c0-17.432-14.132-31.563-31.564-31.563z"></path>
                      </svg>
                      Опасен
                    </div>
                  </div>
                </div>
              </template>
            </template>
            <div v-show="!loading" ref="observer" class="subheading"></div>
          </div>
        </div>
        <div class="basket">
          <div class="basket__information">
            <div class="basket__title">Корзина</div>
            2 астероида
          </div>
          <div class="basket__button">
            Отправить
          </div>
        </div>
      </main>
    </div>
  <div class="bg-img">
    <img src="../assets/earth.jpeg" alt="">
  </div>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  data () {
    return {
      loading: true,
      dataSpase: {},
      nearEarthObjects: [],
      distanceMeasurements: 'lun', // lun/km
      page: -1
    }
  },

  mounted () {
    this.getApp()
    console.log(this.$refs.observer)
    const options = {
      rootMargin: '0px',
      threshold: 1.0
    }

    const callback = (entries, observer) => {
      if (entries[0].isIntersecting) {
        this.getApp()
      }
    }

    const observer = new IntersectionObserver(callback, options)
    observer.observe(this.$refs.observer)
  },

  methods: {
    async getApp () {
      console.log('getApp')
      this.loading = true
      this.page += 1
      const startDate = new Date()
      const endDate = new Date()
      endDate.setDate(startDate.getDate() + this.page)
      // console.log(startDate.getFullYear())
      // console.log(startDate.getMonth() + 1)
      // console.log(startDate.getDate())
      const startDataYYYYMMDD = `${startDate.getFullYear()}-${startDate.getMonth() + 1}-${startDate.getDate()}`
      const endDataYYYYMMDD = `${endDate.getFullYear()}-${endDate.getMonth() + 1}-${endDate.getDate()}`
      const url = 'https://api.nasa.gov/neo/rest/v1/feed'
      await axios.get(url, {
        params: {
          start_date: startDataYYYYMMDD,
          end_date: endDataYYYYMMDD,
          api_key: 'lxFg4mPZkaDYsADeWLV9KdiZQds7T9A8zVih7Yuk'
        }
      }).then(response => {
        this.dataSpase = response.data
        console.log(Object.entries(response.data.near_earth_objects))
        this.nearEarthObjects = Object.entries(response.data.near_earth_objects)
      }).finally(() => {
        this.loading = false
      })
    },
    chooseKilometers () {
      this.distanceMeasurements = 'km'
    },
    chooseLunar () {
      this.distanceMeasurements = 'lun'
    },
    getDistanceMeasurements (item) {
      if (this.distanceMeasurements === 'lun') {
        return Math.round(item.close_approach_data[0].miss_distance.lunar) + ' лунные орбиты'
      }
      if (this.distanceMeasurements === 'km') {
        return Math.round(item.close_approach_data[0].miss_distance.kilometers) + ' километров'
      }
    },
    getNearEarthObjectName (name) {
      return name.slice(1, -1)
    },
    getDiameter (item) {
      return Math.round((item.estimated_diameter.meters.estimated_diameter_max + item.estimated_diameter.meters.estimated_diameter_min) / 2)
    }
  },
  computed: {
  }
}
</script>

<style lang="scss">
@import '../scss/app.scss';

:root {
  --Black: #000;
  --Orange-Base: #F86600;
  --White-Base: #FFF;
  --Orange-Smooth: rgba(248, 102, 0, 0.15);
  --gray-30: #E3E5E5;
}
.bg-img{
  position: fixed;
  width: 377px;
  height: 436px;
  top: calc(50% - 436px / 2);
  left: - 377px / 1.7;
  z-index: 0;
  img{
    width: 100%;
    height: 100%;
  }
}
.subheading{
  width: 1px;
  height: 4px;
  position: absolute;
}
.wrapper{
  widows: 100%;
  min-height: 100vh;
  background-color: var(--Black);
  padding: 16px 16px 96px 16px;
}
.content{
  position: relative;
  z-index: 1;
}

.header__title {
  font-family: Passion One;
  font-size: 32px;
  font-style: normal;
  font-weight: 400;
  line-height: normal;
  color: var(--Orange-Base);
}

.header__text {
  font-family: Helvetica;
  font-size: 16px;
  font-style: normal;
  font-weight: 400;
  line-height: 24px;
}
.main{
  padding: 17px 8px 0 56px;
}

.main__title{
  font-family: Helvetica;
  font-size: 28px;
  font-style: normal;
  font-weight: 700;
  line-height: 36px; /* 128.571% */
  margin-bottom: 8px;
}

.main__toggle{

  font-family: Helvetica;
  font-size: 16px;
  font-style: normal;
  font-weight: 400;
  line-height: 24px; /* 150% */
  margin-bottom: 24px;
  &-active{
    font-weight: 700;
  }
  &-not-active{
    text-decoration-line: underline;
  }
}

.item{
  &:not(:last-child){
  margin-bottom: 24px;
}
  &__title{

    font-family: Helvetica;
    font-size: 24px;
    font-weight: 700;
    font-style: normal;
    line-height: 32px; /* 133.333% */
    margin-bottom: 8px;
  }

  &__info{
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;
  }

  &__distance{
      &-text{
        text-align: center;
        font-size: 16px;
        font-weight: 400;
        line-height: 24px; /* 150% */
      }
  }
  &__right {
    // display: flex;
    &-title {
      font-size: 16px;
      font-weight: 700;
      line-height: 24px; /* 150% */
      text-decoration-line: underline;
    }
    &-size {
      font-size: 12px;
      font-weight: 400;
      line-height: 16px; /* 133.333% */
    }
  }
&__bottom{
  display: flex;
  gap: 10px;
  &-button {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    padding: 2px 11px;
    border-radius: 16px;
    background: var(--Orange-Smooth);

    color: var(--Orange-Base);
    font-size: 11px;
    font-weight: 700;
    line-height: 20px; /* 181.818% */
  }

  &-warning {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 4px;
    color: var(--gray-30);
    font-size: 14px;
    font-weight: 400;
    line-height: 20px; /* 142.857% */
  }

}

}
.basket {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16px;
  background-color: #232526;
  justify-content: space-between;
  align-items: center;
  color: #FFF;
  display: flex;
  font-family: Helvetica;
  font-size: 16px;
  font-style: normal;
  font-weight: 400;
  line-height: 24px;

  &__title{
    font-size: 18px;
    font-style: normal;
    font-weight: 700;
  }
  &__button{
    padding: 12px 16px;
    border-radius: 40px;
    background:  #F86600;
  }
}
</style>
