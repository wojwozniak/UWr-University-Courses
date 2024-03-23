import React from 'react';

interface SectionProps {
  children: React.ReactNode;
  headerText: string;
  name: string;
}

const Section: React.FC<SectionProps> = ({ children, headerText, name }) => {
  return (
    <section id={name} className={name}>
      <h2>
        {headerText}
      </h2>
      <div className="section-content">
        {children}
      </div>
    </section>
  );
};

export default Section;