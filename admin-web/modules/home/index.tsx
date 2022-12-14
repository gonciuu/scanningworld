import GetApp from './components/GetApp';
import Header from './components/Header';
import LoginButton from './components/LoginButton';
import RegisterButton from './components/RegisterButton';

const Home = () => {
  return (
    <div className="flex h-full w-full flex-col items-center justify-center">
      <LoginButton />
      <Header />
      <img src="/images/hero.svg" alt="hero" className="mt-[2vw] w-[25vw]" />
      <RegisterButton />
      <GetApp />
    </div>
  );
};

export default Home;
